//
//  ProgressBar.swift
//  beam-ios-sdk
//
//  Created by ALEXANDRA SALVATORE on 6/28/19.
//  Copyright © 2019 Beam Impact. All rights reserved.
//

import UIKit

internal enum BackgroundTintType {
    case color(UIColor)
    case blur
}

internal class GradientProgressBar: UIView {
    var tintType: BackgroundTintType
    var numerator: CGFloat = 0
    var denominator: CGFloat = 0
    
    var rounded: Bool = true {
        didSet {
            setNeedsLayout()
            layoutIfNeeded()
        }
    }
    
    var progressColorExists: Bool {
        return UIColor.progressColor != nil
    }
    
    private let gradientView: UIView = .init(with: .purple)
    private let rainbowGradient: CAGradientLayer = .progressRainbowGradient
    private let percentFillView: UIView = .init(with: .purple)
    
    private lazy var blurView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.clipsToBounds = true
        return blurEffectView
    }()
    
    init(tintType: BackgroundTintType = .color(.beamGray1)) {
        self.tintType = tintType
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        rainbowGradient.frame = bounds
        let width: CGFloat = denominator == 0 ? 0 : CGFloat(numerator) / CGFloat(denominator)
        percentFillView.frame = CGRect(x: 0, y: 0, width: width * bounds.width, height: bounds.height)
        if useBlur {
            blurView.frame = bounds
            blurView.layer.cornerRadius = rounded ? blurView.bounds.height / 2 : 0
        }
        
        gradientView.layer.cornerRadius = rounded ? gradientView.bounds.height / 2 : 0
        percentFillView.layer.cornerRadius = rounded ? percentFillView.bounds.height / 2 : 0
        layer.cornerRadius = rounded ? bounds.height / 2 : 0
    }
    
    func setup() {
        if useBlur {
            addSubview(blurView)
            backgroundColor = .beamGray1
        } else if case let .color(tint) = tintType {
            backgroundColor = tint
        }
        gradientView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        gradientView.clipsToBounds = true
        percentFillView.clipsToBounds = true
        addSubview(gradientView)
        gradientView.addSubview(percentFillView)
        if progressColorExists {
            percentFillView.backgroundColor = UIColor.progressColor
            gradientView.backgroundColor = UIColor.progressColor
        } else {
            gradientView.layer.addSublayer(rainbowGradient)
        }
        gradientView.mask = percentFillView

    }
    
    var useBlur: Bool {
        if case .blur = tintType {
            return true
        }
        return false
    }
}

extension UIDevice {
    var iPhoneX: Bool {
        return UIScreen.main.nativeBounds.height == 2436
    }
    
    var iPhone: Bool {
        return UIDevice.current.userInterfaceIdiom == .phone
    }
    
    var is5or4Phone: Bool {
        return screenType == .iPhones_4_4S || screenType == .iPhones_5_5s_5c_SE
    }
    
    var is6OrSmaller: Bool {
        return self.is5or4Phone || screenType == .iPhones_6_6s_7_8
    }

    var isPlus: Bool {
        return screenType == .iPhones_6Plus_6sPlus_7Plus_8Plus
    }
    
    var hasNotch: Bool {
        return UIScreen.main.nativeBounds.height >= 2435
       // return screenType == .iPhone_XR || screenType == .iPhones_X_XS || screenType == .iPhone_XSMax
    }
    
    enum ScreenType: String {
        case iPhones_4_4S = "iPhone 4 or iPhone 4S"
        case iPhones_5_5s_5c_SE = "iPhone 5, iPhone 5s, iPhone 5c or iPhone SE"
        case iPhones_6_6s_7_8 = "iPhone 6, iPhone 6S, iPhone 7 or iPhone 8"
        case iPhones_6Plus_6sPlus_7Plus_8Plus = "iPhone 6 Plus, iPhone 6S Plus, iPhone 7 Plus or iPhone 8 Plus"
        case iPhones_X_XS = "iPhone X or iPhone XS"
        case iPhone_XR = "iPhone XR"
        case iPhone_XSMax = "iPhone XS Max"
        case unknown
    }
    var screenType: ScreenType {
        switch UIScreen.main.nativeBounds.height {
        case 960:
            return .iPhones_4_4S
        case 1136:
            return .iPhones_5_5s_5c_SE
        case 1334:
            return .iPhones_6_6s_7_8
        case 1792:
            return .iPhone_XR
        case 1920, 2208:
            return .iPhones_6Plus_6sPlus_7Plus_8Plus
        case 2436:
            return .iPhones_X_XS
        case 2688:
            return .iPhone_XSMax
        default:
            return .unknown
        }
    }
}
