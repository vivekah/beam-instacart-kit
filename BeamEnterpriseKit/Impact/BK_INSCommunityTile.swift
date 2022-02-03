//
//  BK_INSCommunityTile.swift
//  BeamKit
//
//  Created by ALEXANDRA SALVATORE on 10/27/21.
//

import Foundation
import UIKit

public class BK_INSCommunityTile: UIView {
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
        label.text = "World Central Kitchen"
        label.textColor = .instacartTitleGrey
        return label
    }()
    
    let progressBar: GradientProgressBar = .init(tintType: .blur)
    
    
    let regionLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.beamRegular(size: 12)
        label.textAlignment = .left
        label.numberOfLines = 1
        label.backgroundColor = .clear
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.6
        label.text = "Local Nonprofit"
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
        label.lineBreakMode = .byWordWrapping
        label.text = "Fund 10,000 meals to nourish communities impacted by Hurricane Ida"
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
        label.text = "Climate disaster relief"
        label.minimumScaleFactor = 1
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
        label.layer.masksToBounds = false
        return label
    }()
    
    let separatorfirst: UIView = .init(with: .instacartBorderGrey)

    public let ctaButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.titleLabel?.textAlignment = .left
        button.titleLabel?.font = .beamSemiBold(size: 12)
        button.setTitleColor(.instacartDescriptionGrey, for: .normal)
        button.contentHorizontalAlignment = .left;
        button.titleLabel?.lineBreakMode = .byWordWrapping
        button.titleLabel?.numberOfLines = 0
        button.setTitle("To support this goal, <font style='color:#0AAD0A;'> choose this food bank ›</font>", for: .normal)
        return button
    }()
    
    var isFavorite: Bool = false
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = 12
        if isFavorite {
            layer.borderWidth = 3
            layer.borderColor = UIColor.instacartDescriptionGrey.cgColor
        } else {
            layer.borderWidth = 1
            layer.borderColor = UIColor.instacartBorderGrey.cgColor
        }

        nonprofitImage.layer.cornerRadius = 12
    }
    
    func setup() {
        backgroundColor = .white
        addSubview(nonprofitImage.usingConstraints())
        addSubview(nameLabel.usingConstraints())
        addSubview(regionLabel.usingConstraints())
        addSubview(causeLabel.usingConstraints())
        addSubview(infoTextLabelView.usingConstraints())
        addSubview(progressBar.usingConstraints())
        addSubview(percentageLabel.usingConstraints())
        addSubview(separatorfirst.usingConstraints())
        addSubview(ctaButton.usingConstraints())
        
        setupConstraints()
    }
    
    func configure(with nonprofit: BKNonprofit?) {
        nameLabel.text = nonprofit?.name
        causeLabel.text = nonprofit?.cause
        progressBar.numerator = CGFloat(nonprofit?.percentage ?? 0)
        progressBar.denominator = 100
        let percentage = nonprofit?.percentage ?? 0
        percentageLabel.text = "\(percentage)%"
        progressBar.setNeedsLayout()
        regionLabel.text = nonprofit?.badge
        
        if let image = nonprofit?.image,
            let url = URL(string: image) {
                nonprofitImage.bkSetImageWithUrl(url)
        }
        
        if let goal = nonprofit?.impactDescription {
            infoTextLabelView.text = goal
            let style = NSMutableParagraphStyle()
            style.lineHeightMultiple = 1.1
            let attributedString = NSAttributedString(string: goal, attributes: [NSAttributedString.Key.paragraphStyle: style])
            infoTextLabelView.attributedText = attributedString
        }
        
        configureCTA(with: nonprofit)
    }
    
    func configureCTA(with nonprofit: BKNonprofit?) {
        guard let nonprofit = nonprofit else { return }
        isFavorite = nonprofit.isFavorite
        let donationCount = Int(nonprofit.totalDonations)
        let goalCompletion = Int(nonprofit.goalCompletion)
        ctaButton.isEnabled = true
        
        if isFavorite && donationCount > 0 {
            ctaButton.setAttributedTitle("You have contributed <b>\(donationCount) meals</b> toward the goal. This is your selected nonprofit.".bkhtmlAttributedString(), for: .normal)
            backgroundColor = .instacartDisableGrey
            ctaButton.isEnabled = false
        } else if isFavorite {
            ctaButton.setAttributedTitle("Support your chosen foodbank. Just place an order and 1 meal will be funded at no cost to you.".bkhtmlAttributedString(), for: .normal)
            backgroundColor = .instacartDisableGrey
            ctaButton.isEnabled = false
        } else if goalCompletion > 0 {
            backgroundColor = .white
            ctaButton.setAttributedTitle("✅ Instacart has completed this goal \(goalCompletion) times! Help us do it again. <font style='color:#0AAD0A;'>change to this food bank ›</font>".bkhtmlAttributedString(), for: .normal)
        } else if BeamKitContext.shared.getNonprofitName() != nil {
            backgroundColor = .white
            ctaButton.setAttributedTitle("To support this goal, <font style='color:#0AAD0A;'>change to this food bank ›</font>".bkhtmlAttributedString(), for: .normal)
        }
        
        if let cta = nonprofit.impactCTA,
           !cta.isEmpty {
            
            let style = NSMutableParagraphStyle()
            style.lineHeightMultiple = 1.1
            
            if let attrString = cta.bkhtmlAttributedString()?.mutableCopy() as? NSMutableAttributedString {
                let nsstring = NSString(string: attrString.string)
                let range = NSMakeRange(0, nsstring.length)
                attrString.addAttribute(.paragraphStyle, value: style, range: range)
                ctaButton.setAttributedTitle(attrString, for: .normal)
            }
        }

    }
    
    func setupConstraints() {
        let views: Views = ["image": nonprofitImage,
                            "name": nameLabel,
                            "reg": regionLabel,
                            "cause": causeLabel,
                            "goal": infoTextLabelView,
                            "sep": separatorfirst,
                            "bar": progressBar,
                            "per": percentageLabel,
                            "cta": ctaButton]
        
        let formats: [String] = ["V:|-16-[image(152)]-[reg]-2-[name]-2-[cause]-2-[goal]-[bar(6)]-10-[sep(1)]-[cta]-16-|",
                                 "H:|-16-[image]-16-|",
                                 "H:|-16-[reg]-16-|",
                                 "H:|-16-[name]-16-|",
                                 "H:|-16-[cause]-16-|",
                                 "H:|-16-[goal]-16-|",
                                 "H:|-16-[bar]-[per(30)]-16-|",
                                 "H:|-16-[sep]-16-|",
                                 "H:|-16-[cta]-16-|",

        ]
        var constraints = NSLayoutConstraint.constraints(withFormats: formats,
                                                         options: [],
                                                         metrics: nil,
                                                         views: views)
        constraints += [NSLayoutConstraint.init(item: percentageLabel,
                                                attribute: .centerY,
                                                relatedBy: .equal,
                                                toItem: progressBar,
                                                attribute: .centerY,
                                                multiplier: 1.0,
                                                constant: 0)]
    
        NSLayoutConstraint.activate(constraints)
    }
        
}

extension String {
    func bkhtmlAttributedString(with fontSize: CGFloat = 12) -> NSAttributedString? {
        guard let data = self.data(using: .unicode, allowLossyConversion: true) else {
            return nil
        }
        

        return try? NSMutableAttributedString(
            data: data,
            options: [.documentType: NSAttributedString.DocumentType.html],
            documentAttributes: nil
        ).with(font: UIFont.beamRegular(size: fontSize)!)

    }
}

extension NSMutableAttributedString {

    func with(font: UIFont) -> NSMutableAttributedString {
        self.enumerateAttribute(NSAttributedString.Key.font, in: NSMakeRange(0, self.length), options: .longestEffectiveRangeNotRequired, using: { (value, range, stop) in
            let originalFont = value as! UIFont
            if let newFont = applyTraitsFromFont(originalFont, to: font) {
                self.addAttribute(NSAttributedString.Key.font, value: newFont, range: range)
            }
        })
        return self
    }

    func applyTraitsFromFont(_ f1: UIFont, to f2: UIFont) -> UIFont? {
        let originalTrait = f1.fontDescriptor.symbolicTraits

        if originalTrait.contains(.traitBold) {
            var traits = f2.fontDescriptor.symbolicTraits
            traits.insert(.traitBold)
            if let fd = f2.fontDescriptor.withSymbolicTraits(traits) {
                return UIFont.init(descriptor: fd, size: 0)
            }
        }
        return f2
    }
}
