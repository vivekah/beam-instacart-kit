//
//  NonprofitAPI.swift
//  BeamKit
//
//  Created by ALEXANDRA SALVATORE on 9/27/19.
//  Copyright © 2019 Beam Impact. All rights reserved.
//

import UIKit

class NonprofitAPI {
    class func getNonprofits(at storeID: String,
                             _ completion: ((BKStoreNonprofitsModel?, Bool, BeamError) -> Void)? = nil) {
                
        let successHandler: (JSON?) -> Void = {  nonprofitJSON in
            BKLog.info("Did Retrieve Nonprofits for store \(storeID)")
            BKLog.info("Nonprofit JSON \(String(describing: nonprofitJSON))")
            guard let json = nonprofitJSON,
                let model = parseStoreNonprofitJSON(json, for: storeID) else {
                    completion?(nil, false, .invalidConfiguration)
                    return
            }
            let match = json["user_can_match"] as? Bool ?? false
            completion?(model, match, .none)
        }
        
        let errorHandler: (ErrorType) -> Void = { error in
            BKLog.error("Nonprofit Error")
            completion?(nil, false, .networkError)
        }
        
        let language = BeamKitContext.shared.language
        
        guard let userID = BeamKitContext.shared.getUserID() else {
            completion?(nil, false, .invalidUser)
            return
        }
        
        guard let chainID = BeamKitContext.shared.getChainID() else {
            completion?(nil, false, .invalidUser)
            return
        }
        var country = "CA"
        if storeID.isNumeric {
            country = "US"
        }
        
        Network.shared.get(urlPath: "chains/nonprofits/?chain=\(chainID)&postal_code=\(storeID)&country_code=\(country)&partner_user_id=\(userID)&show_community_impact=true&lan=\(language)",
                           successJSONHandler: successHandler,
                           errorHandler: errorHandler)
    }
    
    class func parseStoreNonprofitJSON(_ json: JSON, for storeID: String) -> BKStoreNonprofitsModel? {
        let model = BKStoreNonprofitsModel()
        let lastNon = json["last_nonprofit"] as? Int ?? 0
        
        if let donationInfo =  json["chain_donation_type"] as? JSON {
            let sub = donationInfo["description_mobile"] as? String ?? "Choose a cause to contribute to with your next order, and one meal will be donated there at no extra cost to you."
            let title = donationInfo["title_mobile"] as? String ?? "Fight food insecurity"
            model.title = title
            model.subtitle = sub
            model.cta = donationInfo["choose_cta"] as? String ?? "Choose nonprofit"
            model.complianceCTA = donationInfo["compliance_cta"] as? String
            model.complianceDescription = donationInfo["compliance_description_mobile"] as? String
        }
    
        if let nonprofits = json["nonprofits"] as? [JSON] {
            var parsed = [BKNonprofit]()
            for non in nonprofits {
                let parsed_nonprofit = NonprofitAPI.parseNonprofitJSON(non)
                parsed_nonprofit.storeIDs.insert(storeID)
                parsed.append(parsed_nonprofit)
                if parsed_nonprofit.id == lastNon {
                    model.lastNonprofit = parsed_nonprofit
                }
            }
            if !parsed.isEmpty {
                model.nonprofits = parsed
            }
        }
  
        if let storeJSON = json["store"] as? JSON {
            let storeImage = storeJSON["logo"] as? String
            let name = storeJSON["chain_name"] as? String
            let rectLogo = storeJSON["rect_logo"] as? String
            let store = BKStore(id: storeID,
                                image: storeImage,
                                rect: rectLogo,
                                name: name)
            store.percent = 0.01
            if let percent = storeJSON["donation_percentage"] as? CGFloat {
                store.percent = percent
            }
            if let donationType = storeJSON["chain_donation_type"] as? JSON {
                let name = donationType["name"] as? String
                let amount = donationType["donation_amount"] as? CGFloat ?? 0
                let percent = donationType["donation_percentage"] as? CGFloat ?? 0
                let description = donationType["description_mobile"] as? String
                store.percent = percent
                store.donationName = name
                store.amount = amount
                store.donationDescription = description
            }
            
            if let matchDonationType = storeJSON["match_donation_type"] as? JSON {
                let title = matchDonationType["title"] as? String
                let value = matchDonationType["description"] as? String
                let percent = matchDonationType["donation_percentage"] as? CGFloat
                store.matchTitle = title
                store.matchDescription = value
                store.matchPercent = percent
            }
            model.store = store
        }

        return model
    }
    

    // COULD DO: Raise exception for poorly formed nonprofit??? / return null?
    class func parseNonprofitJSON(_ json: JSON) -> BKNonprofit {
        let name = json["name"] as? String ?? ""
        let id = json["id"] as? Int ?? 0
        let cause = json["cause"] as? String ?? ""
        let impact_description = json["impact_description"] as? String ?? ""
        let descripton = json["description"] as? String
        let image = json["image"] as? String ?? ""
        let badge = json["badge"] as? String ?? "Local Nonprofit"
        
        let impact = json["impact"] as? JSON
        let chain_donated = impact?["chain_donated"] as? CGFloat ?? 0
        let total_donated = impact?["total_donated"] as? CGFloat ?? 0
        let goal_amount = impact?["target_donation_amount"] as? CGFloat ?? 10
        let goal_completion = impact?["goal_completion"] as? CGFloat ?? 0
        var percentage = impact?["percentage"] as? Int ?? 1
        percentage = percentage == 0 ? 1 : percentage
        let impactCTA = impact?["impact_cta"] as? String ?? ""

        let nonprofit = BKNonprofit(cause: cause,
                                    id: id,
                                    description: descripton ?? "",
                                    image: image,
                                    impactDescription: impact_description,
                                    name: name,
                                    chainDonations: chain_donated,
                                    targetDonations: goal_amount,
                                    totalDonations: total_donated,
                                    goalCompletion: goal_completion,
                                    percentage: percentage,
                                    badge: badge,
                                    impactCTA: impactCTA)

        return nonprofit
    }
    
    class func selectNonprofit(id: Int,
                               store: String,
                               cart: CGFloat,
                               match: Bool,
                               matchAmount: Double,
                               position: Int,
                               _ completion: ((Int?, BeamError) -> Void)? = nil) {
        guard let user = BeamKitContext.shared.getUserID() else {
            completion?(nil, .invalidUser)
            return
        }
        
        let body: JSON  = ["customer_id": user,
                           "store_id": store,
                           "cart_total": cart,
                           "nonprofit_id": id,
                           "user_did_match": match,
                           "user_match_amount": matchAmount,
                           "nonprofit_position": position]
        
        let successHandler: (JSON?) -> Void = {  transactionJSON in
            guard let transactionID = transactionJSON?["transaction"] as? Int else {
                BKLog.error("Select Nonprofit: invalid response")
                completion?(nil, .invalidConfiguration)
                return 
            }
            
            BKLog.debug("Beam Registered Transaction with id \(transactionID)")
            completion?(transactionID, .none)
        }
        
        let errorHandler: (ErrorType) -> Void = { error in
            BKLog.error("Select Nonprofit Error")
            completion?(nil, .networkError)
        }
        
        Network.shared.post(urlPath: "users/transaction/",
                            body: body,
                            successJSONHandler: successHandler,
                            errorHandler: errorHandler)
    }
    
    class func registerTransaction(with userID: String? = nil, _ completion: ((Int?, BeamError) -> Void)? = nil) {
        guard let user = BeamKitContext.shared.getUserID() else {
            completion?(nil, .invalidUser)
            return
        }
        BeamKitContext.shared.token = "Fez0xn9XFhur.4c90bd46-40f4-4cd7-a755-4800ea5ad1e3"
        let body: JSON  = ["partner_user_id": userID ?? user,
                           "cart_total": "123",
                           "store_id": "13"]
        
        let successHandler: (JSON?) -> Void = {  transactionJSON in
            guard let transactionID = transactionJSON?["transaction"] as? Int else {
                BKLog.error("Select Nonprofit: invalid response")
                completion?(nil, .invalidConfiguration)
                return
            }
            BeamKitContext.shared.token = "MCT5KmLZUJCf.aecf3e1a-c091-481a-89bc-ae9384b3639c"
            BKLog.debug("Beam Registered Transaction with id \(transactionID)")
            completion?(transactionID, .none)
        }
        
        let errorHandler: (ErrorType) -> Void = { error in
            BKLog.error("Register Transaction Error")
            BeamKitContext.shared.token = "MCT5KmLZUJCf.aecf3e1a-c091-481a-89bc-ae9384b3639c"
            completion?(nil, .networkError)
        }
        
        Network.shared.post(urlPath: "users/transaction",
                            body: body,
                            successJSONHandler: successHandler,
                            errorHandler: errorHandler)
    }
    
    class func cancelTransaction(id: Int,
                               _ completion: ((BeamError) -> Void)? = nil) {
        guard let _ = BeamKitContext.shared.getUserID() else {
            completion?(.invalidUser)
            return
        }

        let successHandler: (JSON?) -> Void = {  _ in

            BKLog.debug("Beam cancelled Transaction with id \(id)")
            completion?(.none)
        }
        
        let errorHandler: (ErrorType) -> Void = { error in
            BKLog.error("Cancel Transaction Error")
            completion?(.networkError)
        }
        
        Network.shared.patch(urlPath: "transaction/?transaction=\(id)",
                            successJSONHandler: successHandler,
                            errorHandler: errorHandler)
    }
    
    class func favorite(id: Int,
                               _ completion: ((BeamError) -> Void)? = nil) {
        guard let user = BeamKitContext.shared.getUserID() else {
            completion?(.invalidUser)
            return
        }

        let successHandler: (JSON?) -> Void = {  _ in

            BKLog.debug("Beam registerred favorite nonprofit with \(id)")
            completion?(.none)
        }
        
        let errorHandler: (ErrorType) -> Void = { error in
            BKLog.error("Favorite Nonprofit Error")
            completion?(.networkError)
        }
        
        guard let chainID = BeamKitContext.shared.getChainID() else {
            completion?(.invalidUser)
            return
        }
        
        let body: JSON  = ["partner_user_id": user,
                           "chain": chainID,
                           "nonprofit": id]
        
        Network.shared.post(urlPath: "users/favorite-nonprofit/",
                            body: body,
                            successJSONHandler: successHandler,
                            errorHandler: errorHandler)
    }
    
    class func parseFavorite(_ json: JSON?) -> BK_INSFavoriteCopy? {
        guard let json = json else { return nil }
        let copy = BK_INSFavoriteCopy()
        copy.title = json["confirmation_message"] as? String
        copy.nonprofit = json["favorite_nonprofit"] as? String
        return copy
    }
    
    class func viewFavorite(_ completion: ((BK_INSFavoriteCopy?, BeamError) -> Void)? = nil) {
        guard let user = BeamKitContext.shared.getUserID() else {
            completion?(nil, .invalidUser)
            return
        }

        let successHandler: (JSON?) -> Void = { favoriteJSON in
            BKLog.info("did get transaction info \(String(describing: favoriteJSON))")
            let copy = NonprofitAPI.parseFavorite(favoriteJSON)
            completion?(copy, .none)
        }
        
        let errorHandler: (ErrorType) -> Void = { error in
            completion?(nil, .networkError)
        }
        
        guard let chainID = BeamKitContext.shared.getChainID() else {
            completion?(nil, .invalidUser)
            return
        }
        
        let language = BeamKitContext.shared.language
        
        Network.shared.get(urlPath: "users/transaction-info?partner_user_id=\(user)&chain=\(chainID)&lan=\(language)",
                            successJSONHandler: successHandler,
                            errorHandler: errorHandler)
    }
}


extension String {
    var isNumeric: Bool {
      return !(self.isEmpty) && self.allSatisfy { $0.isNumber }
    }
}
