//
//  GradientLayer.swift
//  beam-ios-sdk
//
//  Created by ALEXANDRA SALVATORE on 6/28/19.
//  Copyright © 2019 Beam Impact. All rights reserved.
//

import UIKit

extension CAGradientLayer {
    
    internal class var rainbowGradient: CAGradientLayer {
        let gradient = CAGradientLayer()
        
        gradient.colors = [UIColor.beamGradientBlue.cgColor,
                           UIColor.beamGradientYellow.cgColor,
                           UIColor.beamGradientOrange.cgColor]
        gradient.startPoint = CGPoint(x: 0.5, y: 0.25)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.75)
        
        return gradient
    }
    
    internal class var progressRainbowGradient: CAGradientLayer {
        let gradient = CAGradientLayer()
        
        gradient.colors = [UIColor.beamGradientBlue.cgColor,
                           UIColor.beamGradientYellow.cgColor,
                           UIColor.beamGradientOrange.cgColor]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        
        return gradient
    }
    
    internal class var beamGradient: CAGradientLayer {
        let gradient: CAGradientLayer = .init()
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradient.colors = [UIColor.beamGradientLightYellow.cgColor,
                           UIColor.beamGradientLightOrange.cgColor]
        return gradient
    }
    
    internal class var beamBlueGreenGradient: CAGradientLayer {
        let gradient: CAGradientLayer = .init()
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradient.colors = [UIColor.beamBlue4.cgColor,
                           UIColor.beamGreen3.cgColor]
        return gradient
    }
    
    internal class var beamFadeGradient: CAGradientLayer {
        let gradient: CAGradientLayer = .init()
        gradient.startPoint = CGPoint(x: 1.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradient.colors = [UIColor.clear.cgColor,
                           UIColor.black.cgColor]
        return gradient
    }
}
