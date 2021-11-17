//
//  BKImpact.swift
//  BeamKit
//
//  Created by ALEXANDRA SALVATORE on 10/12/19.
//  Copyright © 2019 Beam Impact. All rights reserved.
//

import UIKit

class BKImpact {
    let chainName: String
    let nonprofits: [BKNonprofit]
    let logo: String?
    
    init(chainName: String,
         logo: String?,
         nonprofits: [BKNonprofit]) {
        self.chainName = chainName
        self.logo = logo
        self.nonprofits = nonprofits
    }
}

class BK_INSTutorialCopy {
    var subtitle: String?
    var title: String?
    var cta: String?
    var image: String?
}

class BK_INSCopy {
    var subtitle: String?
    var title: String?
    var impactCTA: String? 
    var complianceCTA: String?
    var complianceDescription: String?
    
    var personalImpactTitle: String?
    var personalImpactDescription: String?
    var personalImpactCTA: String?
    var personalImpactAmt: Int = 0

    var cummulativeImpactTitle: String?
    var cummulativeImpactDescription: String?
    var cummulativeImpactCTA: String?
    
    var communityImpactTitle: String?
    
    var tutorial: [BK_INSTutorialCopy] = []
}

class BK_INSImpact {
    let nonprofits: [BKNonprofit]
    let copy: BK_INSCopy
    var personalImpactImage: String? = ""
    let favoriteName: String?
    
    init(copy: BK_INSCopy,
         nonprofits: [BKNonprofit],
         name: String?) {
        self.nonprofits = nonprofits
        self.copy = copy
        self.favoriteName = name
    }
}
