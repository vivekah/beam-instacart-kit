//
//  BK_INSToolTip.swift
//  BeamKit
//
//  Created by ALEXANDRA SALVATORE on 11/1/21.
//

import Foundation
import UIKit

class BK_INSToolTip: UIView  {
    
    enum ToolTipPosition: Int {
         case left
         case right
         case middle
     }
    let contentView: UIView = .init(with: .instacartComplianceBlue)
    
    let carrotImageView: UIImageView = {
        let view = UIImageView(frame: .zero)
        view.backgroundColor = .clear
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        let bundle = BeamKitContext.shared.bundle
        let image = UIImage(named: "Carrot", in: bundle, compatibleWith: nil)
        view.image = image
        return view
    }()
    
    var tipPosition : ToolTipPosition = .left
    
    let toolTipLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = .beamRegular(size: 10)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.backgroundColor = .instacartComplianceBlue
        label.adjustsFontSizeToFitWidth = true
        label.textColor = .white
        return label
    }()
    
    convenience init(text : String, tipPos: ToolTipPosition) {
        self.init(frame: .zero)
        self.tipPosition = tipPos
        toolTipLabel.text = text
        setup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true;
    }
    
    func setup() {
        isHidden = true
        addSubview(contentView.usingConstraints())
        contentView.addSubview(toolTipLabel.usingConstraints())
        addSubview(carrotImageView.usingConstraints())
        setupConstraints()
    }
    
    func setupConstraints() {
        let views: Views = ["label": toolTipLabel,
                            "content": contentView,
                            "carrot": carrotImageView]
        
        let formats: [String] = ["H:|-16-[label]-16-|",
                                 "V:|-16-[label]-16-|",
                                 "H:|-20-[carrot]",
                                 "H:|[content]|",
                                 "V:|[carrot][content]|",

        ]
        let constraints = NSLayoutConstraint.constraints(withFormats: formats,
                                                         options: [],
                                                         metrics: nil,
                                                         views: views)

    
        NSLayoutConstraint.activate(constraints)
        
    }
    
    func toggleShow() {
        if isHidden {
            performShow()
        } else {
            performHide()
        }
    }
    
    lazy var heightConstraint: NSLayoutConstraint = heightAnchor.constraint(equalToConstant: 0)
    
    func performShow() {
//        let oldFrame = self.frame
//        layer.position = oldFrame.origin
       // layer.anchorPoint = CGPoint(x: 0, y: 0)
        heightConstraint.isActive = true
        //transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
      //  let scaledTransform =  CGAffineTransform(scaleX: 0.01, y: 0.01)
       // transform = scaledTransform
        isHidden = false
        
        UIView.animate(withDuration: 0.3, delay: 0.3, options: .curveEaseOut, animations: {
           // self.transform = .identity
            self.heightConstraint.isActive = false
            self.setNeedsDisplay()
        })    { finished in
            // do something once the animation finishes, put it here
        }
        
    }
    
    func performHide() {
        isHidden = false
       // let oldAnchor = layer.anchorPoint

        UIView.animate(withDuration: 0.3, delay: 0.3, options: .curveEaseOut, animations: {
            //self.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        })    { finished in
            self.isHidden = true
            // do something once the animation finishes, put it here
        }
    }
}


extension UIView {
    func applyTransform(withScale scale: CGFloat, anchorPoint: CGPoint) {
        layer.anchorPoint = anchorPoint
        let scale = scale != 0 ? scale : CGFloat.leastNonzeroMagnitude
        let xPadding = 1/scale * (anchorPoint.x - 0.5)*bounds.width
        let yPadding = 1/scale * (anchorPoint.y - 0.5)*bounds.height
        transform = CGAffineTransform(scaleX: scale, y: scale).translatedBy(x: xPadding, y: yPadding)
    }
}
