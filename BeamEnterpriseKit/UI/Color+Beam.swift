//
//  Color.swift
//  beam-ios-sdk
//
//  Created by ALEXANDRA SALVATORE on 6/28/19.
//  Copyright © 2019 Beam Impact. All rights reserved.
//

import UIKit

extension UIColor {
    
    internal class var beamOrange: UIColor {
        return UIColor(red: (254.0/255.0), green: (155.0/255.0), blue: (84.0/255.0), alpha: 1.0)
    }
    
    internal class var beamGradientBlue: UIColor {
        return UIColor(red: (133.0/255.0), green: (188.0/255.0), blue: (215.0/255.0), alpha: 1.0)
    }
    
    static var _bottomColor: UIColor = UIColor(red: (247.0/255.0), green: (206.0/255.0), blue: (104.0/255.0), alpha: 1.0)
    
    internal class var beamGradientYellow: UIColor {
        return UIColor(red: (251.0/255.0), green: (235.0/255.0), blue: (99.0/255.0), alpha: 1.0)
    }
    
    class func register(bottom: UIColor) {
        _bottomColor = bottom
    }
    
    static var _topColor: UIColor = UIColor(red: (251.0/255.0), green: (171.0/255.0), blue: (126.0/255.0), alpha: 1.0)
    
    internal class var beamGradientOrange: UIColor {
        return  UIColor(red: (255.0/255.0), green: (148.0/255.0), blue: (75.0/255.0), alpha: 1.0)
    }
    
    class func register(top: UIColor) {
        _topColor = top
    }
    
    internal class var beamGradientLightOrange: UIColor {
        return _topColor
    }
    
    internal class var beamGradientLightYellow: UIColor {
        return _bottomColor
    }
    
    static var _progress: UIColor?
    
    internal class var progressColor: UIColor? {
        return _progress
    }
    
    class func register(progress: UIColor) {
        _progress = progress
    }
    
    static var _accent: UIColor = UIColor.white
    
    internal class var accent: UIColor {
        return _accent
    }
    
    class func register(accent: UIColor) {
        _accent = accent
    }
}

// 4 - Darkest 1 - Lightest
// YELLOWS
//
//#FDCB08 RGB(252,202,8) HSL(47.7, 97.6%, 51%) CMYK(0,20,97,1)
//#FBEA60 RGB(251,234,96) HSL(53.4, 95.1%, 68%) CMYK(0,7,62,2)
//#FDF5B0 RGB(253,245,176) HSL(53.8, 95.1%, 84.1%) CMYK(0,3,30,1)
//#FEF9DE RGB(254,249,222) HSL(50.6, 94.1%, 93.3%) CMYK(0,2,13,0)

extension UIColor {
    internal class var beamYellow4: UIColor {
        return UIColor(red: (252.0/255.0), green: (202.0/255.0), blue: (8.0/255.0), alpha: 1.0)
    }
    internal class var beamYellow3: UIColor {
        return UIColor(red: (251.0/255.0), green: (234.0/255.0), blue: (96.0/255.0), alpha: 1.0)
    }
    internal class var beamYellow2: UIColor {
        return UIColor(red: (253.0/255.0), green: (245.0/255.0), blue: (176.0/255.0), alpha: 1.0)
    }
    internal class var beamYellow1: UIColor {
        return UIColor(red: (254.0/255.0), green: (249.0/255.0), blue: (222.0/255.0), alpha: 1.0)
    }
}

// ORANGES
//
//#F78332 RGB(247,131,50) HSL(24.7, 92.5%, 58.2%) CMYK(0,47,80,3)
//#F79957 RGB(247,153,87) HSL(24.7, 90.9%, 65.5%) CMYK(0,38,65,3)
//#FCCDAD RGB(252,205,173) HSL(24.3, 92.9%, 83.3%) CMYK(0,19,31,1)
//#FEF1E7 RGB(254,241,231) HSL(26.1, 92%, 95.1%) CMYK(0,5,9,0)

extension UIColor {
    internal class var beamOrange4: UIColor {
        return _mainOrange
    }
    
    static var _mainOrange: UIColor = UIColor(red: (247.0/255.0), green: (131.0/255.0), blue: (50.0/255.0), alpha: 1.0)
    
    internal class var beamOrange3: UIColor {
        return UIColor(red: (247.0/255.0), green: (153.0/255.0), blue: (87.0/255.0), alpha: 1.0)
    }
    internal class var beamOrange2: UIColor {
        return UIColor(red: (252.0/255.0), green: (205.0/255.0), blue: (173.0/255.0), alpha: 1.0)
    }
    internal class var beamOrange1: UIColor {
        return UIColor(red: (254.0/255.0), green: (241.0/255.0), blue: (231.0/255.0), alpha: 1.0)
    }
    
    class func register(main: UIColor) {
        _mainOrange = main
    }
    
    
}

// BLUES
//
//#5885C4 RGB(19,136,216) HSL(215, 47.8%, 55.7%) CMYK(55,32,0,23)
//#72ACDD RGB(114,172,221) HSL(207.5, 61.1%, 65.7%) CMYK(48,22,0,13)
//#B9D8F1 RGB(185,216,241) HSL(206.8, 66.7%, 83.5%) CMYK(23,10,0,5)
//#EAF4FC RGB(234,244,252) HSL(206.7, 75%, 95.3%) CMYK(7,3,0,1)

extension UIColor {
    internal class var beamBlue4: UIColor {
        return UIColor(red: (19.0/255.0), green: (136.0/255.0), blue: (216.0/255.0), alpha: 1.0)
    }
    internal class var beamBlue3: UIColor {
        return UIColor(red: (114.0/255.0), green: (172.0/255.0), blue: (221.0/255.0), alpha: 1.0)
    }
    internal class var beamBlue2: UIColor {
        return UIColor(red: (185.0/255.0), green: (216.0/255.0), blue: (241.0/255.0), alpha: 1.0)
    }
    internal class var beamBlue1: UIColor {
        return UIColor(red: (234.0/255.0), green: (244.0/255.0), blue: (252.0/255.0), alpha: 1.0)
    }
}

// GREENS
//
//#FDCB08 RGB(66,202,124) HSL(145.6, 56.2%, 52.5%) CMYK(67,0,39,21)
//#7BDFA6 RGB(123,223,166) HSL(145.8, 61%, 67.8%) CMYK(45,0,26,13)
//#BDF2D4 RGB(189,242,212) HSL(146, 67.1%, 84.5%) CMYK(22,0,12,5)
//#EBFCF2 RGB(235,252,242) HSL(144.7, 73.9%, 95.5%) CMYK(7,0,4,1)

extension UIColor {
    internal class var beamGreen4: UIColor {
        return UIColor(red: (66.0/255.0), green: (202.0/255.0), blue: (124.0/255.0), alpha: 1.0)
    }
    internal class var beamGreen3: UIColor {
        return UIColor(red: (123.0/255.0), green: (223.0/255.0), blue: (166.0/255.0), alpha: 1.0)
    }
    internal class var beamGreen2: UIColor {
        return UIColor(red: (189.0/255.0), green: (242.0/255.0), blue: (212.0/255.0), alpha: 1.0)
    }
    internal class var beamGreen1: UIColor {
        return UIColor(red: (235.0/255.0), green: (252.0/255.0), blue: (242.0/255.0), alpha: 1.0)
    }
}

// GRAYS
//
//#59595B RGB(89,89,91) HSL(240, 1.1%, 35.3%) CMYK(2,2,0,64)
//#7A7A7C RGB(122,122,124) HSL(240, 0.8%, 48.2%) CMYK(2,2,0,51)
//#A7A7A7 RGB(167,167,167) HSL(0, 0%, 65.5%) CMYK(0,0,0,35)
//#E9E8E7 RGB(233,232,231) HSL(30, 4.3%, 91%) CMYK(0,0,1,9)

extension UIColor {
    internal class var beamGray4: UIColor {
        return UIColor(red: (89.0/255.0), green: (89.0/255.0), blue: (91.0/255.0), alpha: 1.0)
    }
    internal class var beamGray3: UIColor {
        return UIColor(red: (122.0/255.0), green: (122.0/255.0), blue: (124.0/255.0), alpha: 1.0)
    }
    internal class var beamGray2: UIColor {
        return UIColor(red: (167.0/255.0), green: (167.0/255.0), blue: (167.0/255.0), alpha: 1.0)
    }
    internal class var beamGray1: UIColor {
        return UIColor(red: (233.0/255.0), green: (232.0/255.0), blue: (231.0/255.0), alpha: 1.0)
    }
}


extension UIColor {
    internal class var instacartDescriptionGrey: UIColor {
        UIColor(red: (114.0/255.0), green: (118.0/255.0), blue: (126.0/255.0), alpha: 1.0)
    }
    
    internal class var instacartTitleGrey: UIColor {
        return  UIColor(red: (52.0/255.0), green: (53.0/255.0), blue: (56.0/255.0), alpha: 1.0)
    }
    
    internal class var instacartGreen: UIColor {
        return UIColor(red: (10.0/255.0), green: (173.0/255.0), blue: (10.0/255.0), alpha: 1.0)
    }
    
    internal class var instacartBeamOrange: UIColor {
        return UIColor(red: (233.0/255.0), green: (115.0/255.0), blue: (0.0/255.0), alpha: 1.0)
    }
    
    internal class var instacartDisableGrey: UIColor {
        return UIColor(red: (246.0/255.0), green: (247.0/255.0), blue: (248.0/255.0), alpha: 1.0)
    }
    
    internal class var instacartBorderGrey: UIColor {
        return UIColor(red: (232.0/255.0), green: (233.0/255.0), blue: (238.0/255.0), alpha: 1.0)
    }
    
    //rgba(31, 90, 150, 1)
    internal class var instacartComplianceBlue: UIColor {
        return UIColor(red: (31.0/255.0), green: (90.0/255.0), blue: (150.0/255.0), alpha: 1.0)
    }
}
