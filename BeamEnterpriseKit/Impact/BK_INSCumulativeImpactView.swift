//
//  BK_INSCumulativeImpactView.swift
//  BeamKit
//
//  Created by ALEXANDRA SALVATORE on 10/27/21.
//

import Foundation
import UIKit

public class BK_INSCumulativeImpactView: UIView {
    weak var delegate: BK_INSImpactVCDelegate?
    
    private let titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.backgroundColor = .clear
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 1
        label.text = "Together we’ve funded 27,571 meals nationwide"
        label.textColor = .instacartTitleGrey
        label.font = .beamBold(size: 23)
        return label
    }()
    
    let subLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.beamRegular(size: 15)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.backgroundColor = .clear
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 1
        label.text = "We’ve partnered with hundreds of local and national charities. "
        label.textColor = .instacartDescriptionGrey
        return label
    }()

    
    public let ctaButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.font = .beamSemiBold(size: 12)
        button.setTitleColor(.instacartGreen, for: .normal)
        button.setTitle("Review national impact", for: .normal)
        return button
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    func setup() {
        backgroundColor = .white
        addSubview(titleLabel.usingConstraints())
        addSubview(subLabel.usingConstraints())
        addSubview(ctaButton.usingConstraints())
        
        setupConstraints()
        ctaButton.addTarget(self, action: #selector(didPressButton), for: .touchUpInside)
    }
    
    func configure(with impact: BK_INSImpact?) {
        guard let impact = impact else { return }
        titleLabel.text = impact.copy.cummulativeImpactTitle
        subLabel.text = impact.copy.cummulativeImpactDescription
        ctaButton.setTitle(impact.copy.cummulativeImpactCTA, for: .normal)
        
        if let sub = impact.copy.cummulativeImpactDescription {
            self.subLabel.text = sub
            let style = NSMutableParagraphStyle()
            style.lineHeightMultiple = 1.25
            style.alignment = .center
            let attributedString = NSAttributedString(string: sub, attributes: [NSAttributedString.Key.paragraphStyle: style])
            self.subLabel.attributedText = attributedString
        }
        
        if let title = impact.copy.cummulativeImpactTitle {
            self.titleLabel.text = title
            let style = NSMutableParagraphStyle()
            style.lineHeightMultiple = 1.04
            style.alignment = .center
            let attributedString = NSAttributedString(string: title, attributes: [NSAttributedString.Key.paragraphStyle: style])
            self.titleLabel.attributedText = attributedString
        }
    }
    
    func setupConstraints() {
        let views: Views = ["title": titleLabel,
                            "sub": subLabel,
                            "cta": ctaButton]
        
        let formats: [String] = ["V:|-[title]-[sub]-[cta]-|",
                                 "H:|-16-[sub]-16-|",
                                 "H:|-16-[title]-16-|",
                                 "H:|-16-[cta]-16-|",

        ]
        let constraints = NSLayoutConstraint.constraints(withFormats: formats,
                                                         options: [],
                                                         metrics: nil,
                                                         views: views)
    
        NSLayoutConstraint.activate(constraints)
    }
    
    @objc
    func didPressButton() {
        delegate?.didRequestToViewNationalImpact()
    }
}

