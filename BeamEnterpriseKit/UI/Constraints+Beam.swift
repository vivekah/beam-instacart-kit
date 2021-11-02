//
//  Constraints+Beam.swift
//  beam-ios-sdk
//
//  Created by ALEXANDRA SALVATORE on 6/28/19.
//  Copyright © 2019 Beam Impact. All rights reserved.
//

import UIKit

internal typealias Constraints = [NSLayoutConstraint]

extension NSLayoutConstraint {
    class func constraints(withFormats formats: [String],
                           options opts: NSLayoutConstraint.FormatOptions = [],
                           metrics: [String : Any]? = nil,
                           views: Views) -> Constraints {
        
        var constraints: [NSLayoutConstraint] = []
        
        for format in formats {
            constraints += NSLayoutConstraint.constraints(withVisualFormat: format,
                                                          options: opts,
                                                          metrics: metrics,
                                                          views: views)
        }
        return constraints
    }
    
    class func center(_ view: UIView, in otherView: UIView) -> Constraints {
        return  [NSLayoutConstraint.centerOnX(view, in: otherView),
                 NSLayoutConstraint.centerOnY(view, in: otherView)]
    }
    
    class func centerOnX(_ view: UIView, in otherView: UIView) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: view,
                                  attribute: .centerX,
                                  relatedBy: .equal,
                                  toItem: otherView,
                                  attribute: .centerX,
                                  multiplier: 1.0,
                                  constant: 0)
    }
    
    class func centerOnY(_ view: UIView, in otherView: UIView) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: view,
                                  attribute: .centerY,
                                  relatedBy: .equal,
                                  toItem: otherView,
                                  attribute: .centerY,
                                  multiplier: 1.0,
                                  constant: 0)
    }
    
    class func constrainHeight(_ view: UIView, by constant: CGFloat) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: view,
                                  attribute: .height,
                                  relatedBy: .equal,
                                  toItem: nil,
                                  attribute: .notAnAttribute,
                                  multiplier: 1.0,
                                  constant: constant)
    }
    
    class func constrainWidth(_ view: UIView, by constant: CGFloat) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: view,
                                  attribute: .width,
                                  relatedBy: .equal,
                                  toItem: nil,
                                  attribute: .notAnAttribute,
                                  multiplier: 1.0,
                                  constant: constant)
    }
        
        class func square(_ view: UIView) -> NSLayoutConstraint {
            return NSLayoutConstraint(item: view,
                                        attribute: .width,
                                        relatedBy: .equal,
                                        toItem: view,
                                        attribute: .height,
                                        multiplier: 1.0,
                                        constant: 0.0)
          }

}
