//
//  BKImpactContext.swift
//  BeamKit
//
//  Created by ALEXANDRA SALVATORE on 11/14/19.
//  Copyright © 2019 Beam Impact. All rights reserved.
//

import UIKit

extension Notification.Name {
    static let _bkDidUpdateImpact = Notification.Name("bk_did_update_impact")
    static let _bkDidUpdateCommunityImpact = Notification.Name("bk_did_update_community")
}

class BKImpactContext {
    
    lazy var api: ImpactAPI = .init()
    
    var impact: BKImpact? = nil {
        didSet {
            NotificationCenter.default.post(name: ._bkDidUpdateImpact, object: nil)
        }
    }
    var communityImpact: BKImpact? = nil {
        didSet {
            NotificationCenter.default.post(name: ._bkDidUpdateCommunityImpact, object: nil)
        }
    }
    
    var instacartImpact: BK_INSImpact? = nil {
        didSet {
            NotificationCenter.default.post(name: ._bkDidUpdateCommunityImpact, object: nil)
        }
    }
    
    var instacartCopy: BK_INSImpact? = nil

    var numberOfNonprofits: Int {
        return self.impact?.nonprofits.count ?? 0
    }
    
    var nonprofits: [BKNonprofit]? {
        return self.impact?.nonprofits
    }
    
    // TODO surface errors in UI slash to devs
    
    func loadImpact(_ completion: ((BKImpact?, BeamError) -> Void)? = nil) {
        api.getImpact { impact, error in
            defer {
                completion?(impact, error)
            }
            guard error == BeamError.none,
                let impact = impact else {
                    return
            }
            self.impact = impact
        }
    }
    
    func loadCommunityImpact() {
        api.getCommunityImpact() { impact, error in
            guard error == BeamError.none,
                let impact = impact else {
                    return
            }
            self.communityImpact = impact
        }
    }
    
    func getImpact(for nonprofit: BKNonprofit, _ completion: ((BKNonprofit?, BeamError) -> Void)? = nil) {
        api.getImpact(for: nonprofit, completion)
    }
    
    func clearImpact() {
        impact = nil
        communityImpact = nil
        instacartImpact = nil
    }
    
    func loadInstacartImpact(zip: String = "", _ completion: ((BeamError) -> Void)? = nil) {
        api.getInstacartImpact(zip: zip) { impact, error in
            guard error == BeamError.none,
                let impact = impact else {
                    completion?(error)
                    return
            }
            self.instacartImpact = impact
            completion?(.none)
        }
    }
    
    func loadPersonalInstacartImpact(userID: String, _ completion: ((BK_INSImpact?, BeamError) -> Void)? = nil) {
        api.getPersonalInstacartImpact(user: userID) { impact, error in
            guard error == BeamError.none,
                let impact = impact else {
                    completion?(nil, error)
                    return
            }
            BKLog.info("impact \(impact)")
            self.instacartCopy = impact
            completion?(impact, error)
        }
    }
}
