//
//  UIView+Beam.swift
//  beam-ios-sdk
//
//  Created by ALEXANDRA SALVATORE on 6/26/19.
//  Copyright © 2019 Beam Impact. All rights reserved.
//

import UIKit

internal typealias Views = [String: UIView]

extension UIView {
    
    static var beamDefaultNavBarHeight: CGFloat = 45

    internal convenience init(with color: UIColor) {
        self.init(frame: .zero)
        self.backgroundColor = color
    }
    
    internal func usingConstraints() -> UIView {
        self.translatesAutoresizingMaskIntoConstraints = false
        return self
    }
}
