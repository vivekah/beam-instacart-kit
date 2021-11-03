//
//  BK_INSNonprofitButton.swift
//  BeamKit
//
//  Created by ALEXANDRA SALVATORE on 10/16/21.
//

import UIKit

protocol BK_INSNonprofitButtonDelegate {
    func didSelect(_ id: BKNonprofit?, button: BK_INSNonprofitButton)
}

internal class BK_INSNonprofitButton: UIButton {
    var nonprofit: BKNonprofit?
    var delegate: BK_INSNonprofitButtonDelegate?
    
    lazy var selectTap = UITapGestureRecognizer(target: self, action: #selector(didTap))
    
    let selectViewTapTarget: UIView = .init(with: .clear)
    
    let nonprofitImage: UIImageView = {
        let view = UIImageView(frame: .zero)
        view.backgroundColor = .instacartDisableGrey
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()
        
    let nameLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIDevice.current.is5or4Phone ? UIFont.beamBold(size: 20) : UIFont.beamBold(size: 18)
        label.textAlignment = .left
        label.numberOfLines = 2
        label.backgroundColor = .clear
        label.adjustsFontSizeToFitWidth = true
   //     label.minimumScaleFactor = 0
        label.textColor = .instacartTitleGrey
        return label
    }()
    
    let progressBar: GradientProgressBar = .init(tintType: .blur)
    
    
    let regionLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.beamRegular(size: 10)
        label.textAlignment = .left
        label.numberOfLines = 1
        label.backgroundColor = .clear
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.6
        label.textColor = .instacartTitleGrey
        return label
    }()
    
    let infoTextLabelView: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.beamRegular(size: 12)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.backgroundColor = .clear
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        label.textColor = .instacartTitleGrey
        return label
    }()
    
    let causeLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIDevice.current.is5or4Phone ? UIFont.beamSemiBold(size: 11.0) : UIFont.beamSemiBold(size: 12.0)
        label.textAlignment = .left
        label.numberOfLines = 1
        label.textColor = .instacartBeamOrange
        label.backgroundColor = .clear
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        return label
    }()
    
    let percentageLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIDevice.current.is5or4Phone ? UIFont.beamRegular(size: 11.0) : UIFont.beamRegular(size: 12.0)
        label.textAlignment = .right
        label.numberOfLines = 1
        label.textColor = .instacartDescriptionGrey
        label.backgroundColor = .clear
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        return label
    }()
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = 12
        if isSelected {
            layer.borderWidth = 3
            layer.borderColor = UIColor.instacartDescriptionGrey.cgColor
        } else {
            layer.borderWidth = 1
            layer.borderColor = UIColor.instacartBorderGrey.cgColor
        }

        nonprofitImage.layer.cornerRadius = 12
    }
    
    func configure(with nonprofit: BKNonprofit?) {
        guard let nonprofit = nonprofit else {
            self.isHidden = true
            return
        }
        self.nonprofit = nonprofit
        if let url = URL(string: nonprofit.image) {
            nonprofitImage.bkSetImageWithUrl(url)
        }
        
        progressBar.denominator = nonprofit.targetDonations
        progressBar.numerator = nonprofit.totalDonations.truncatingRemainder(dividingBy: nonprofit.targetDonations)
        progressBar.setNeedsLayout()

        regionLabel.text = nonprofit.badge
        causeLabel.text = nonprofit.cause
        percentageLabel.text = "\(nonprofit.percentage)" + "%"

        
        // info text
        let goal = nonprofit.impactDescription
        infoTextLabelView.text = goal
        let style = NSMutableParagraphStyle()
        style.lineHeightMultiple = 1.25
        let attributedString = NSAttributedString(string: goal, attributes: [NSAttributedString.Key.paragraphStyle: style])
        infoTextLabelView.attributedText = attributedString
        
        // name label
        let name = nonprofit.name
        nameLabel.text = name
        let attributedNameString = NSAttributedString(string: name, attributes: [NSAttributedString.Key.paragraphStyle: style])
        nameLabel.attributedText = attributedNameString
    }
    
    func setup() {
        
        addSubview(nonprofitImage.usingConstraints())
        addSubview(nameLabel.usingConstraints())
        addSubview(progressBar.usingConstraints())
        addSubview(causeLabel.usingConstraints())
        addSubview(regionLabel.usingConstraints())
        addSubview(infoTextLabelView.usingConstraints())
        addSubview(percentageLabel.usingConstraints())
        
        addSubview(selectViewTapTarget.usingConstraints())
        
        isUserInteractionEnabled = true
        selectViewTapTarget.addGestureRecognizer(selectTap)
        
        setupConstraints()
    }
    
    func setupConstraints() {
        let views: Views = ["image": nonprofitImage,
                            "name": nameLabel,
                            "bar": progressBar,
                            "region": regionLabel,
                            "desc": infoTextLabelView,
                            "cause": causeLabel,
                            "per": percentageLabel,
                            "select": selectViewTapTarget]
        let formats: [String] = ["H:|-[image(78)]-[name]-|",
                                 "H:[image]-[cause]-|",
                                 "H:[image]-[region]-|",
                                 "H:|-[desc]-|",
                                 "H:|-[bar]-[per(35)]-15-|",
                                 "H:|[select]|",
                                 "V:|[select]|",
                                 "V:|-[image(78)]-[desc]-[bar(6)]-10-|",
                                 "V:[region]-2-[name]-4-[cause]"]
        var constraints: Constraints =
            NSLayoutConstraint.constraints(withFormats: formats, views: views)
        
        constraints += [NSLayoutConstraint.init(item: percentageLabel,
                                                attribute: .centerY,
                                                relatedBy: .equal,
                                                toItem: progressBar,
                                                attribute: .centerY,
                                                multiplier: 1,
                                                constant: 0),
                        NSLayoutConstraint.init(item: nameLabel,
                                                attribute: .centerY,
                                                relatedBy: .equal,
                                                toItem: nonprofitImage,
                                                attribute: .centerY,
                                                multiplier: 1,
                                                constant: -2)]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    func makeSelected() {
        isSelected = true
        layer.borderWidth = 3
        layer.borderColor = UIColor.instacartDescriptionGrey.cgColor
    }
    
    func deslect() {
        isSelected = false
        layer.borderWidth = 1
        layer.borderColor = UIColor.instacartBorderGrey.cgColor
    }
}

extension BK_INSNonprofitButton {

    
    @objc
    func didTap() {
        self.delegate?.didSelect(nonprofit, button: self)
    }
}

extension BK_INSNonprofitButton: UIGestureRecognizerDelegate {
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}


