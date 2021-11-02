//
//  BKImpactSlideView.swift
//  BeamKit
//
//  Created by ALEXANDRA SALVATORE on 1/29/20.
//  Copyright © 2020 Beam Impact. All rights reserved.
//

import UIKit

protocol BKImpactSlideViewDelegate: class {
    func didSelectMyImpact()
    func didSelectGlobal()
}

class BKImpactSlideView: UIView {
    
    weak var delegate: BKImpactSlideViewDelegate? = nil
    
    let myImpactLabel: BKSelectionLabel = .init(title: "MY IMPACT")
    let globalLabel: BKSelectionLabel = .init(title: "COMMUNITY IMPACT" )
    
    lazy var slideIndicator: UIView = .init(with: myImpactLabel.selectedColor)
    lazy var impactCenter: NSLayoutConstraint =
        .init(item: slideIndicator,
              attribute: .centerX,
              relatedBy: .equal,
              toItem: myImpactLabel,
              attribute: .centerX,
              multiplier: 1,
              constant: 0)
    lazy var impactWidth: NSLayoutConstraint = .init(item: slideIndicator,
                                                   attribute: .width,
                                                   relatedBy: .equal,
                                                   toItem: myImpactLabel,
                                                   attribute: .width,
                                                   multiplier: 1,
                                                   constant: 0)
    lazy var globalCenter: NSLayoutConstraint =
        .init(item: slideIndicator,
              attribute: .centerX,
              relatedBy: .equal,
              toItem: globalLabel,
              attribute: .centerX,
              multiplier: 1,
              constant: 0)
    lazy var globalWidth: NSLayoutConstraint = .init(item: slideIndicator,
                                                  attribute: .width,
                                                  relatedBy: .equal,
                                                  toItem: globalLabel,
                                                  attribute: .width,
                                                  multiplier: 1,
                                                  constant: 0)
    
    
  
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        slideIndicator.layer.cornerRadius = slideIndicator.bounds.height / 2
    }
    
    func setupViews() {
        addSubview(slideIndicator.usingConstraints())
        addSubview(myImpactLabel.usingConstraints())
        addSubview(globalLabel.usingConstraints())
        setupGestures()
        setupConstraints()
        didSelectMyImpact()
    }
    
    func setupConstraints() {
        let views: [String: UIView] = ["list": myImpactLabel,
                                       "map": globalLabel,
                                       "slide": slideIndicator]
        let formats: [String] = ["V:|-5-[list]-7-[slide(3)]|",
                                 "V:|[map]-8-|",
                                 "H:[slide]->=5-|",
                                 "H:|[list]-12-[map]-5-|"]
        
        var constraints: [NSLayoutConstraint] =
            NSLayoutConstraint.constraints(withFormats: formats, views: views)
        
        constraints +=
            [impactWidth,
             impactCenter]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    func setupGestures() {
        isUserInteractionEnabled = true
        let listGR = UITapGestureRecognizer(target: self, action: #selector(didSelectMyImpact))
        myImpactLabel.addGestureRecognizer(listGR)
        let mapGR = UITapGestureRecognizer(target: self, action: #selector(didSelectGlobal))
        globalLabel.addGestureRecognizer(mapGR)
    }
    
    @objc func didSelectMyImpact() {
        globalLabel.toggle(selected: false)
        myImpactLabel.toggle(selected: true)
        NSLayoutConstraint.deactivate([globalCenter, globalWidth])
        NSLayoutConstraint.activate([impactCenter, impactWidth])
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.15, animations: {
                self.layoutIfNeeded()
            })
        }
        delegate?.didSelectMyImpact()
    }
    
    @objc func didSelectGlobal() {
        myImpactLabel.toggle(selected: false)
        globalLabel.toggle(selected: true)
        NSLayoutConstraint.deactivate([impactCenter, impactWidth])
        NSLayoutConstraint.activate([globalCenter, globalWidth])
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.15, animations: {
                self.layoutIfNeeded()
            })
        }
        delegate?.didSelectGlobal()
    }
    
    override var intrinsicContentSize: CGSize {
        let width = globalLabel.intrinsicContentSize.width +
                myImpactLabel.intrinsicContentSize.width + 17
        let height = myImpactLabel.intrinsicContentSize.height + 15
        return CGSize(width: width, height: height)
    }
}


class BKSelectionLabel: UILabel {

    private var isSelected: Bool = false
    private(set) var selectedColor: UIColor = .beamOrange4
    private var defaultColor: UIColor = .beamGray3
    private var _tintColor: UIColor {
        return self.isSelected ? selectedColor : defaultColor
    }
    private var selectedFont: UIFont? = .beamSemiBold(size: 14)
    private var defaultFont: UIFont? = .beamRegular(size: 14)
    private var _font: UIFont? {
        return self.isSelected ? selectedFont : defaultFont
    }
//    private let titleLabel: UILabel = {
//        let label = UILabel(frame: .zero)
//        label.textAlignment = .left
//        label.numberOfLines = 1
//        label.backgroundColor = .clear
//        label.adjustsFontSizeToFitWidth = true
//        label.minimumScaleFactor = 0.8
//        label.textColor = .beamGray3
//        label.font = .beamSemiBold(size: 12)
//        label.lineBreakMode = .byTruncatingTail
//        return label
//    }()
    
    init(title: String) {
        super.init(frame: .zero)
        text = title
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        textAlignment = .left
        numberOfLines = 1
        backgroundColor = .clear
        adjustsFontSizeToFitWidth = true
        minimumScaleFactor = 0.6
        textColor = .beamGray3
        font = .beamSemiBold(size: 14)
        lineBreakMode = .byTruncatingTail
        isUserInteractionEnabled = true
    }

    func toggle(selected: Bool, animated: Bool = true) {
        isSelected = selected
        UIView.animate(withDuration: 0.1) { [weak self] in
            guard let `self` = self else { return }
            self.textColor = self._tintColor
          // self.font = self._font
        }
    }
}
