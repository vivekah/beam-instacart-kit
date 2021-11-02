//
//  Font+Beam.swift
//  beam-ios-sdk
//
//  Created by ALEXANDRA SALVATORE on 6/26/19.
//  Copyright © 2019 Beam Impact. All rights reserved.
//

import UIKit

internal class FontIdentifiers {
    static var regular: String = "Poppins-Regular"
    static var bold: String = "Poppins-Bold"
    static var semiBold: String = "Poppins-SemiBold"
}

extension UIFont {
    
    internal class func beamRegular(size: CGFloat) -> UIFont? {
        return UIFont(name: FontIdentifiers.regular , size: size)
    }
    
    internal class func beamBold(size: CGFloat) -> UIFont? {
        return UIFont(name: FontIdentifiers.bold , size: size)
    }
    
    internal class func beamSemiBold(size: CGFloat) -> UIFont? {
        return UIFont(name: FontIdentifiers.semiBold , size: size)
    }
    
    class func registerFont(for name: String) {
        FontIdentifiers.regular = name
    }
    
    class func registerBoldFont(for name: String) {
        FontIdentifiers.bold = name
    }
    
    class func registerSemiBoldFont(for name: String) {
        FontIdentifiers.semiBold = name
    }
    
//    class func confirmFont(fonts: [String]) {
//        for family: String in UIFont.familyNames
//        {
//            let names = UIFont.fontNames(forFamilyName: family)
//            for font in fonts {
//                if names.contains(font) {
//                    notRegistered.remove(font)
//                }
//            }
//        }
//    }
}

extension UIFont {
    
    // load framework font in application
    public class func _bkLoadAllFonts() {
        let bundle = BeamKitContext.shared.bundle
        
        let fontsToLoad = [FontIdentifiers.bold,
                           FontIdentifiers.regular,
                           FontIdentifiers.semiBold]
        for font in fontsToLoad {
            UIFont.load(fontName: font, in: bundle)
        }
    }
    
    public class func load(fontName: String, in bundle: Bundle) {
        guard let fontURL = bundle.url(forResource: fontName, withExtension: ".ttf") else {
            BKLog.critical("couldn't load font \(fontName)")
            return
        }
        guard let fontDataProvider = CGDataProvider(url: fontURL as CFURL) else {
            BKLog.critical("Couldn't load data from the font \(fontName)")
            return
        }

        guard let font = CGFont(fontDataProvider) else {
            BKLog.critical("Couldn't create font from data \(fontName)")
            return
        }
        var error: Unmanaged<CFError>?

        let success = CTFontManagerRegisterGraphicsFont(font, &error)
        guard success else {
            BKLog.error("Error registering font: maybe it was already registered.")
            return
        }
    }
}
