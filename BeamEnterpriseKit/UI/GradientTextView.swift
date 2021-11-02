//
//  GradientTextView.swift
//  BeamKit
//
//  Created by ALEXANDRA SALVATORE on 1/28/20.
//  Copyright © 2020 Beam Impact. All rights reserved.
//

import UIKit

class GradientTextView: UIView {
    let _colors: [CGColor]
    let gradient: CAGradientLayer = .init()
    var textAlignment: NSTextAlignment = .center {
        didSet {
            label.textAlignment = textAlignment
        }
    }
    
    var numberOfLines: Int = 0 {
        didSet {
            label.numberOfLines = numberOfLines
        }
    }
    
    var text: String = "" {
        didSet {
            label.text = text
            setNeedsLayout()
            layoutIfNeeded()
        }
    }
    
    private let label: UILabel = {
        let label = UILabel(frame: .zero)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .beamGray3
        label.backgroundColor = .clear
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        label.font = UIFont.beamBold(size: 17)
        return label
    }()
    
    init(with colors: [CGColor],
         text: String,
         font: UIFont?) {
        _colors = colors
        super.init(frame: .zero)
        label.text = text
        gradient.colors = colors
        label.font = font
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradient.frame = bounds
        label.frame = bounds
    }
    
    func setupViews() {
        layer.addSublayer(gradient)
        addSubview(label)
        mask = label
    }
    
    override var intrinsicContentSize: CGSize {
        label.sizeToFit()
        label.layoutIfNeeded()
        return label.intrinsicContentSize
    }
    
    func toggleActive(on: Bool) {
        if on {
            gradient.colors = _colors
        } else {
            gradient.colors = [UIColor.beamGray3.cgColor,
                               UIColor.beamGray2.cgColor]
        }
    }
}
