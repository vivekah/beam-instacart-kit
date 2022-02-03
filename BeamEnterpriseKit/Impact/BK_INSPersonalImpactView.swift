//
//  BK_INSPersonalImpactView.swift
//  BeamKit
//
//  Created by ALEXANDRA SALVATORE on 10/27/21.
//

import UIKit

public protocol BK_INSPersonalImpactDelegate: AnyObject {
    func didSelectButton(with favorite: String?)
}

public class BK_INSPersonalImpactView: UIView {
    weak var delegate: BK_INSPersonalImpactDelegate?
    
    let nonprofitImage: UIImageView = {
        let view = UIImageView(frame: .zero)
        view.backgroundColor = .instacartDisableGrey
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        let bundle = BeamKitContext.shared.bundle
        let image = UIImage(named: "Personal_Beam", in: bundle, compatibleWith: nil)
        view.image = image
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textAlignment = .left
        label.numberOfLines = 2
        label.backgroundColor = .clear
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 1
        label.lineBreakMode = .byWordWrapping
        label.text = "Support your nonprofit"
        label.textColor = .instacartTitleGrey
        label.font = .beamSemiBold(size: 15)
        return label
    }()
    
    let subLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.beamRegular(size: 12)
        label.textAlignment = .left
        label.numberOfLines = 2
        label.backgroundColor = .clear
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 1
        label.lineBreakMode = .byWordWrapping
        label.text = "Just place an order and they’ll get one meal donated, at no extra cost to you."
        label.textColor = .instacartTitleGrey
        return label
    }()
    
    let progressBar: GradientProgressBar = .init(tintType: .blur)
    
    let percentageLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.beamRegular(size: 12.0)
        label.textAlignment = .right
        label.numberOfLines = 1
        label.textColor = .instacartDescriptionGrey
        label.backgroundColor = .clear
        label.adjustsFontSizeToFitWidth = true
        label.text = "1%"
        label.minimumScaleFactor = 0.8
        return label
    }()
    
    public let ctaButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.titleLabel?.textAlignment = .left
        button.titleLabel?.font = .beamSemiBold(size: 12)
        button.setTitleColor(.instacartGreen, for: .normal)
        button.contentHorizontalAlignment = .left;
        //button.setTitle("Select a nonprofit", for: .normal)
        return button
    }()
    
    var progressHeight: NSLayoutConstraint? = nil
    var showCTA: Bool = true
    var verticalConstraints: [NSLayoutConstraint]? = nil
    var viewDict: Views? = nil
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    public init(showCTA: Bool, delegate: BK_INSPersonalImpactDelegate?) {
        super.init(frame: .zero)
        self.delegate = delegate
        setup(showCTA: showCTA)
    }
    
    var context: BKImpactContext {
        return BeamKitContext.shared.impactContext
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        nonprofitImage.layer.cornerRadius = nonprofitImage.bounds.height / 2
    }
    
    func setup(showCTA: Bool = true) {
        self.showCTA = showCTA
        backgroundColor = .white
        addSubview(nonprofitImage.usingConstraints())
        addSubview(titleLabel.usingConstraints())
        addSubview(subLabel.usingConstraints())
        addSubview(progressBar.usingConstraints())
        addSubview(percentageLabel.usingConstraints())
        addSubview(ctaButton.usingConstraints())
        
        setupConstraints()
        if !showCTA {
            ctaButton.isHidden = true
        }
        ctaButton.addTarget(self, action: #selector(didPressButton), for: .touchUpInside)
    }
    
    func configure(with impact: BK_INSImpact?) {
        guard let impact = impact else { return }
        titleLabel.text = impact.copy.personalImpactTitle
        subLabel.text = impact.copy.personalImpactDescription
        ctaButton.setTitle(impact.copy.personalImpactCTA, for: .normal)
        if let html = impact.copy.personalImpactHTMLCTA {
            ctaButton.setAttributedTitle(html.bkhtmlAttributedString(), for: .normal)
            ctaButton.titleLabel?.numberOfLines = 0
            ctaButton.titleLabel?.lineBreakMode = .byWordWrapping
        }
        let numerator = CGFloat(impact.copy.personalImpactAmt)
        progressBar.numerator = numerator
        progressBar.denominator = 100
        percentageLabel.text = String(impact.copy.personalImpactAmt) + "%"
        progressBar.setNeedsLayout()

        
        if let image = impact.personalImpactImage,
           let imageURL = URL(string: image) {
            nonprofitImage.bkSetImageWithUrl(imageURL)
        }
        
        if let title = impact.copy.personalImpactTitle {
            self.titleLabel.text = title
        }
        
        if let sub = impact.copy.personalImpactDescription {
            self.subLabel.text = sub
            let style = NSMutableParagraphStyle()
            style.lineHeightMultiple = 1.1
            let attributedString = NSAttributedString(string: sub, attributes: [NSAttributedString.Key.paragraphStyle: style])
            self.subLabel.attributedText = attributedString
        }
        reconstrain(with: numerator)
    }
    
    public
    func configure(with userID: String) {
        context.loadPersonalInstacartImpact(userID: userID) { impact, error in
            DispatchQueue.main.async {
                self.configure(with: impact)
            }
        }
    }
    
    func reconstrain(with percent: CGFloat) {
        guard let views = viewDict else { return }
        let hideProgress = showCTA
        progressBar.isHidden = hideProgress
        percentageLabel.isHidden = hideProgress
        progressHeight?.constant = hideProgress ? 0 : 6
        
        var vertFormats = ["V:|-[image]-4-[sub]-[bar]-[cta]-|",
                           "H:|-16-[cta]-16-|"]
        if !showCTA {
            vertFormats = ["V:|-[image]-4-[sub]-11-[bar]-|"]
        } else if hideProgress && showCTA {
            vertFormats = ["V:|-[image]-4-[sub]-4-[cta]-|",
                        "H:|-16-[cta]-16-|"]
        } else if hideProgress && !showCTA {
            vertFormats = ["V:|-[image]-4-[sub]-|"]
        }
        
        NSLayoutConstraint.deactivate(verticalConstraints!)

        verticalConstraints = NSLayoutConstraint.constraints(withFormats: vertFormats,
                                                             options: [],
                                                             metrics: nil,
                                                             views: views)
            
        NSLayoutConstraint.activate(verticalConstraints!)
        setNeedsLayout()
    }
    
    
    func setupConstraints() {
        let views: Views = ["image": nonprofitImage,
                            "title": titleLabel,
                            "sub": subLabel,
                            "bar": progressBar,
                            "per": percentageLabel,
                            "cta": ctaButton]
        viewDict = views
        let formats: [String] = ["H:|-16-[image(52)]-16-[title]",
                                 "V:|-[image(52)]",
                                 "V:|-[title]",
                                 "H:|-16-[sub]-16-|",
                                 "H:|-16-[bar]-[per(30)]-16-|",
                                 ]
        var constraints = NSLayoutConstraint.constraints(withFormats: formats,
                                                         options: [],
                                                         metrics: nil,
                                                         views: views)
        progressHeight = NSLayoutConstraint(item: progressBar,
                                            attribute: .height,
                                            relatedBy: .equal,
                                            toItem: nil,
                                            attribute: .notAnAttribute,
                                            multiplier: 1.0,
                                            constant: 6.0)
        
        constraints += [progressHeight!,
                        NSLayoutConstraint.init(item: percentageLabel,
                                                attribute: .centerY,
                                                relatedBy: .equal,
                                                toItem: progressBar,
                                                attribute: .centerY,
                                                multiplier: 1.0,
                                                constant: 0),
                        NSLayoutConstraint.init(item: ctaButton,
                                                attribute: .height,
                                                relatedBy: .equal,
                                                toItem: ctaButton.titleLabel,
                                                attribute: .height,
                                                multiplier: 1.0,
                                                constant: 0),
                        NSLayoutConstraint.init(item: titleLabel,
                                                attribute: .trailing,
                                                relatedBy: .equal,
                                                toItem: progressBar,
                                                attribute: .trailing,
                                                multiplier: 1.0,
                                                constant: 0),
                        
        ]
        
        var vertFormats = ["V:|-[image]-4-[sub]-[bar]-[cta]-|",
                           "H:|-82-[cta]-16-|"]
        if !showCTA {
            vertFormats = ["V:|-[image]-4-[sub]-11-[bar]-|"]
        }
        verticalConstraints = NSLayoutConstraint.constraints(withFormats: vertFormats,
                                                             options: [],
                                                             metrics: nil,
                                                             views: views)
        NSLayoutConstraint.activate(verticalConstraints!)
        NSLayoutConstraint.activate(constraints)
    }
    
    @objc
    func didPressButton() {
        var name = context.instacartCopy?.favoriteName
        if let id = context.instacartImpact?.favoriteID {
            name = String(id)
        }
        delegate?.didSelectButton(with: name)
    }
    
}

public class BK_INSPostPurchaseView: UIView {
    var flow: BKChooseNonprofitFlow {
        return BeamKitContext.shared.chooseFlow
    }
    
    let nonprofitImage: UIImageView = {
        let view = UIImageView(frame: .zero)
        view.backgroundColor = .clear
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        let bundle = BeamKitContext.shared.bundle
        let image = UIImage(named: "Personal_Beam", in: bundle, compatibleWith: nil)
        view.image = image
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.backgroundColor = .clear
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 2
        label.text = "Your order has funded a meal for someone in need"
        label.textColor = .instacartTitleGrey
        label.font = .beamBold(size: 18)
        return label
    }()
    
    let subLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.beamRegular(size: 12)
        label.textAlignment = .center
        label.numberOfLines = 1
        label.backgroundColor = .clear
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 1
        label.text = "Test Nonprofit"
        label.textColor = .instacartTitleGrey
        return label
    }()
    
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        nonprofitImage.layer.cornerRadius = nonprofitImage.bounds.height / 2
    }
    
    func setup() {
        backgroundColor = .white
        addSubview(nonprofitImage.usingConstraints())
        addSubview(titleLabel.usingConstraints())
        addSubview(subLabel.usingConstraints())
        
        setupConstraints()
        let name = BeamKitContext.shared.getNonprofitName()
        subLabel.text = name
        configure()
    }
    
    public
    func configure() {
        let name = BeamKitContext.shared.getNonprofitName()
        subLabel.text = name
        
        flow.viewFavorite() { copy, error in
            DispatchQueue.main.async {
                self.subLabel.text = copy?.nonprofit
                self.titleLabel.text = copy?.title ?? "Your order has funded a meal for someone in need"
            }
        }
    }
    
    func setupConstraints() {
        let views: Views = ["image": nonprofitImage,
                            "title": titleLabel,
                            "sub": subLabel]
        
        let formats: [String] = ["H:|->=16-[image(50)]->=16-|",
                                 "V:|-[image(50)]-[title]-[sub]-|",
                                 "H:|-16-[sub]-16-|",
                                 "H:|-16-[title]-16-|",

        ]
        var constraints = NSLayoutConstraint.constraints(withFormats: formats,
                                                         options: [],
                                                         metrics: nil,
                                                         views: views)
        constraints += [
            NSLayoutConstraint.init(item: nonprofitImage,
                                    attribute: .centerX,
                                    relatedBy: .equal,
                                    toItem: self,
                                    attribute: .centerX,
                                    multiplier: 1,
                                    constant: 0)
        ]

    
        NSLayoutConstraint.activate(constraints)
    }
}

