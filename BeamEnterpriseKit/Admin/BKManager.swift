//
//  Manager.swift
//  beam-ios-sdk
//
//  Created by ALEXANDRA SALVATORE on 6/26/19.
//  Copyright © 2019 Beam Impact. All rights reserved.
//

import UIKit

public class BKManager: NSObject {
    
    public init(with key: String,
         environment: BKEnvironment,
         logLevel: BKLogLevel,
         language: String? = "en",
         chainID: Int? = nil,
         options: [String: Any]?) {
        BKLog.logLevel = logLevel
        super.init()
        BeamKitContext.shared.register(with: key, lan: language, environment: environment)
        BeamKitContext.shared.saveChain(id: chainID)
        process(options)
    }
        
    public func registerUser(id: String? = nil,
                      info: [String: Any]? = nil,
                      _ completion: ((String?, BeamError) -> Void)? = nil) {
        return BeamKitContext.shared.registerUser(id: id, info: info, completion)
    }
    
    public func registerCustomBackButton(image: UIImage, tint: UIColor) {
        BKBackButton.register(backImage: image, tint: tint)
    }
    
    public func deregisterUser(_ completion: ((BeamError) -> Void)? = nil) {
        BeamKitContext.shared.deregisterUser()
    }
}

extension BKManager {
    public func beginTransaction(at storeID: String,
                                 spend: CGFloat,
                                 forceMatchView: Bool = false,
                                 email: String? = nil,
                                 _ completion: ((BKChooseNonprofitViewType?, BeamError) -> Void)? = nil) {
        BeamKitContext.shared.chooseContext.beginTransaction(at: storeID,
                                                             for: spend,
                                                             forceMatchView: forceMatchView,
                                                             email: email,
                                                             completion)
        
     }
    
    public func prepareSelection(at zip: String,
                               user: String? = nil,
                               _ completion: ((BeamError) -> Void)? = nil) {
        BeamKitContext.shared.registerPartnerUser(id: user, info: nil) { _, error in
            if error != .none {
                completion?(error)
                return
            }
            BeamKitContext.shared.chooseContext.beginTransaction(at: zip,
                                                                 for: 100) { _, error in
                completion?(error)
            }
        }
        
     }
    
    public func completeCurrentTransaction(_ completion: ((Int?, BeamError) -> Void)? = nil) {
        guard let transaction = BeamKitContext.shared.chooseContext.currentTransaction else {
            completion?(nil, .invalidConfiguration)
            return
        }
        BeamKitContext.shared.complete(transaction) { transactionID, error in
          //  if error != nil {
                BeamKitContext.shared.chooseContext.currentTransaction = nil
          //  }
            completion?(transactionID, error)
        }
    }
    
    
    public func register(_ completion: ((BeamError) -> Void)? = nil) {

        BeamKitContext.shared.register(completion)
    }

    public func webRegister(_ completion: ((BeamError) -> Void)? = nil) {

        BeamKitContext.shared.register(with: "partnerUserIdSnez1", completion)
    }
    
    public func cancelTransaction(id: Int,
                                  _ completion: ((BeamError) -> Void)? = nil) {
        BeamKitContext.shared.chooseContext.cancelTransaction(id: id, completion)
    }
    
}

extension BKManager {
    fileprivate func process(_ options: JSON?) {
        guard let options = options else {
            UIFont._bkLoadAllFonts()
            return
        }
        if let regularFont = options["BeamCustomFontKey"] as? String,
            let boldFont = options["BeamCustomBoldFontKey"] as? String,
            let semiBoldFont = options["BeamCustomSemiBoldFontKey"] as? String {
           // UIFont.confirm([regularFont, boldFont, semiBoldFont])
            UIFont.registerFont(for: regularFont)
            UIFont.registerBoldFont(for: boldFont)
            UIFont.registerSemiBoldFont(for: semiBoldFont)
        } else {
            UIFont._bkLoadAllFonts()
            //todo more logging where we notify if one was set & not the others
            BKLog.debug("Beam configured with default Poppins Font")
        }
        if let top = options["BeamCustomGradientTopColorKey"] as? UIColor {
            UIColor.register(top: top)
        }
        if let bottom = options["BeamCustomGradientBottomColorKey"] as? UIColor {
            UIColor.register(bottom: bottom)
        }
        if let main = options["BeamCustomMainColorKey"] as? UIColor {
            UIColor.register(main: main)
        }
        if let progress = options["BeamCustomProgressColorKey"] as? UIColor {
            UIColor.register(progress: progress)
        }
        if let accent = options["BeamCustomAccentColorKey"] as? UIColor {
            UIColor.register(accent: accent)
        }
    }
}

