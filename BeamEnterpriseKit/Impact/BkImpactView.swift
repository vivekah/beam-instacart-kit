//
//  BkImpactView.swift
//  BeamKit
//
//  Created by ALEXANDRA SALVATORE on 11/14/19.
//  Copyright © 2019 Beam Impact. All rights reserved.
//

import UIKit

public protocol BKImpactViewDelegate: AnyObject {
    var baseViewController: UIViewController { get }
}

public enum BKImpactDisplayType {
    case classic
    case wordsBelowImage
}

public class BKImpactView: UIView {
    
    lazy var flow: BKImpactFlow = .init()
    weak var delegate: BKImpactViewDelegate?
    let type: BKImpactDisplayType
    
    public var titleFont: UIFont? = .beamBold(size: 24) {
        didSet {
            nameLabel.font = titleFont
        }
    }
    
    public var buttonFont: UIFont? = .beamRegular(size: 14) {
        didSet {
            seeMoreButton.titleLabel?.font = buttonFont
        }
    }
    
    public var descriptionFont: UIFont? = .beamRegular(size: 13) {
        didSet {
            descriptionLabel.font = descriptionFont
        }
    }
    
    public var buttonColor: UIColor = .beamOrange4 {
        didSet {
            seeMoreButton.backgroundColor = buttonColor
            seeMoreButton.set(color: buttonColor)
        }
    }
    
    public var buttonTitleColor: UIColor = .white {
        didSet {
            seeMoreButton.setTitleColor(buttonTitleColor, for: .normal)
        }
    }
    
    public var descriptionColor: UIColor = .beamGray3 {
        didSet {
            descriptionLabel.textColor = descriptionColor
        }
    }
    
    public var buttonCornerRadius: CGFloat = 2.0 {
        didSet {
            seeMoreButton.layer.cornerRadius = buttonCornerRadius
        }
    }
    
    public var emptyStateTitle: String = "MAKE AN IMPACT WITH US"

    let backgroundImage: UIImageView = {
        let view = UIImageView(frame: .zero)
        view.backgroundColor = .clear
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.layer.masksToBounds = true
        return view
    }()
    
    let tintView: UIView = .init(with: .beamGray3)
    
    let causeLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.beamRegular(size: 11.0)
        label.textAlignment = .left
        label.numberOfLines = 1
        label.textColor = .white
        label.backgroundColor = .clear
        return label
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = .beamBold(size: 24)
        label.textAlignment = .left
        label.numberOfLines = 1
        label.backgroundColor = .clear
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.6
        label.textColor = .white
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = .beamRegular(size: 13)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.backgroundColor = .clear
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.6
        label.text = "Every time you order with us, we will donate to a nonprofit of your choice. Place your first order to select your nonprofit"
        label.textColor = .beamGray3
        return label
    }()
    
    let poweredByLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.beamRegular(size: 9)
        label.textAlignment = .center
        label.numberOfLines = 1
        label.backgroundColor = .clear
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.6
        label.textColor = .white
        label.text = "Powered by"
        return label
    }()
    
    lazy var beamLogoImageView: UIImageView = {
        let view = UIImageView(frame: .zero)
        view.backgroundColor = .clear
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        let bundle = BeamKitContext.shared.bundle
        let image = UIImage(named: "bkLogo", in: bundle, compatibleWith: nil)?.maskWithColor(color: .white)
        view.image = image
        return view
    }()
    
    let poweredByView: UIView = .init(with: .clear)
    
    let progressBar: GradientProgressBar = .init(tintType: .blur)
    
    let seeMoreButton: BKGradientButton = {
        let button = BKGradientButton(frame: .zero)
        button.setTitle("See More of Your Impact", for: .normal)
        button.titleLabel?.font = .beamRegular(size: 14)
        button.roundCorners = false
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.minimumScaleFactor = 0.6
        return button
    }()
    
    let changeButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.titleLabel?.font = .beamBold(size: 15.0)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.numberOfLines = 0
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.setTitle("See the Community Impact", for: .normal)
        button.backgroundColor = .clear
        button.layer.borderWidth = 3
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.cornerRadius = 15
        button.clipsToBounds = true
        return button
    }()
    
    var lunchBoxTitle: String {
        return UIDevice.current.is6OrSmaller ? "LEARN MORE" : "LEARN MORE ABOUT OUR NONPROFITS"
    }
    
    var impactConstraints: [NSLayoutConstraint] = .init()
    var emptyConstraints: [NSLayoutConstraint] = .init()
    
    override init(frame: CGRect) {
        type = .classic
        super.init(frame: frame)
        setup()
    }
    
    public init(type: BKImpactDisplayType = .classic,
                frame: CGRect,
                delegate: BKImpactViewDelegate) {
        self.delegate = delegate
        self.type = type
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        clipsToBounds = true
        layer.masksToBounds = true
        if case .classic = type {
            setupClassic()
        } else {
            setupWordsBelow()
        }
        
        listen()
    }
    
    func finishSetup() {
        loadImpact()

        isUserInteractionEnabled = true
        backgroundImage.isUserInteractionEnabled = true
        seeMoreButton.isUserInteractionEnabled = true
        changeButton.isHidden = true
        descriptionLabel.isHidden = true
        changeButton.addTarget(self, action: #selector(seeGlobal), for: .touchUpInside)
    }
        
    func setupClassic() {
        tintView.alpha = 0.25

        addSubview(backgroundImage.usingConstraints())
        backgroundImage.addSubview(tintView.usingConstraints())
        backgroundImage.addSubview(nameLabel.usingConstraints())
        backgroundImage.addSubview(progressBar.usingConstraints())
        backgroundImage.addSubview(causeLabel.usingConstraints())
        backgroundImage.addSubview(poweredByView.usingConstraints())
        poweredByView.addSubview(poweredByLabel.usingConstraints())
        poweredByView.addSubview(beamLogoImageView.usingConstraints())
        backgroundImage.addSubview(changeButton.usingConstraints())
        addSubview(seeMoreButton.usingConstraints())
        seeMoreButton.addTarget(self, action: #selector(seeMore), for: .touchUpInside)

        setupConstraints()
        finishSetup()
    }
    
    func setupConstraints() {
        let views: Views = ["back": backgroundImage,
                            "tint": tintView,
                            "name": nameLabel,
                            "bar": progressBar,
                            "cause": causeLabel,
                            "change": changeButton,
                            "learn": seeMoreButton,
                            "pb": poweredByView,
                            "pblabel": poweredByLabel,
                            "logo": beamLogoImageView]
        let pbFormats: [String] = [ "H:|->=1-[logo]->=1-|",
                                    "V:|[pblabel][logo(40)]|",
                                    "H:|[tint]|",
                                    "V:|[tint]|",
                                    "H:|[back]|"]
        var pbConstraints: Constraints =
            NSLayoutConstraint.constraints(withFormats: pbFormats, views: views)
        pbConstraints += [NSLayoutConstraint.centerOnX(beamLogoImageView, in: poweredByView)]
        NSLayoutConstraint.activate(pbConstraints)

        
        let formats: [String] = ["H:|-30-[name]-[pb(50)]-15-|",
                                 "H:|-30-[bar]-40-|",
                                 "H:|[learn]|",
                                 "V:|[back][learn(30)]|",
                                 "H:|-30-[cause]->=10-|",
                                 "V:|-8-[cause]->=3-[name]-10-[bar(8)]-10-|",
                                 "V:[cause]-1-[pb]"]
        impactConstraints +=
             NSLayoutConstraint.constraints(withFormats: formats, views: views)
        
        let emptyFormats: [String] = ["V:|[back]|",
                                      "H:|-15-[pb(60)]-8-[change]-15-|",
                                      "V:|->=3-[pb]->=3-|",
                                      "V:|->=3-[change]->=3-|"]
        emptyConstraints += NSLayoutConstraint.constraints(withFormats: emptyFormats, views: views)
        emptyConstraints += [NSLayoutConstraint.centerOnY(poweredByView, in: backgroundImage),
                             NSLayoutConstraint.centerOnY(changeButton, in: backgroundImage)]

    }
    
    func setupWordsBelow() {
        addSubview(backgroundImage.usingConstraints())
        addSubview(nameLabel.usingConstraints())
        nameLabel.textColor = .beamOrange4
        nameLabel.textAlignment = .center
        nameLabel.minimumScaleFactor = 0.8
        nameLabel.numberOfLines = 0
        addSubview(descriptionLabel.usingConstraints())
        addSubview(progressBar.usingConstraints())
        addSubview(seeMoreButton.usingConstraints())
        seeMoreButton.layer.cornerRadius = buttonCornerRadius
        seeMoreButton.setTitle("SEE MORE OF YOUR IMPACT", for: .normal)
        finishSetup()
        seeMoreButton.addTarget(self, action: #selector(seeEither), for: .touchUpInside)
        setupWordsBelowConstraints()
    }
    
    func setupWordsBelowConstraints() {
        let views: Views = ["back": backgroundImage,
                            "name": nameLabel,
                            "bar": progressBar,
                            "desc": descriptionLabel,
                            "learn": seeMoreButton]
        let formats: [String] = ["H:|-30-[name]-30-|",
                                 "H:|-10-[bar]-10-|",
                                 "H:|-20-[learn]-20-|",
                                 "H:|[back]|",
                                 "V:[bar(8)]-15-[name(>=30)]-15-[learn]-20-|",
                                 "V:|[back]"]
        impactConstraints +=
             NSLayoutConstraint.constraints(withFormats: formats, views: views)
        impactConstraints += [NSLayoutConstraint(item: progressBar,
                                                 attribute: .centerY,
                                                 relatedBy: .equal,
                                                 toItem: backgroundImage,
                                                 attribute: .bottom,
                                                 multiplier: 1.0,
                                                 constant: 0),

                              NSLayoutConstraint.constrainHeight(seeMoreButton, by: seeMoreButton.intrinsicContentSize.height)]
        
        let emptyFormats: [String] = ["H:|-20-[name]-20-|",
                                 "H:|-30-[desc]-30-|",
                                 "H:|-20-[learn]-20-|",
                                 "V:|-20-[name]-10-[desc]-10-[learn]-20-|"]
        emptyConstraints += NSLayoutConstraint.constraints(withFormats: emptyFormats, views: views)
        
    }
    
    public func loadImpact(forceReload: Bool = false) {
        if let first = flow.context.nonprofits?.first,
            !forceReload {
            update(with: first, name: flow.context.impact?.chainName)
            return
        }
        flow.context.loadImpact() { [weak self] impact, error in
            guard let `self` = self else { return }
            DispatchQueue.main.async {
                self.update(with: impact?.nonprofits.first, name: impact?.chainName)
            }
        }
    }
    
    func update(with nonprofit: BKNonprofit?, name: String?) {
        guard let nonprofit = nonprofit else {
            setupEmptyState(with: name)
            return
        }
        let image = nonprofit.image
        if let url = URL(string: image) {
            backgroundImage.bkSetImageWithUrl(url)
        } else {
            let bundle = BeamKitContext.shared.bundle
            let image = UIImage(named: "kidbackground", in: bundle, compatibleWith: nil)
            backgroundImage.image = image
        }
        nameLabel.text = nonprofit.name
        if case .wordsBelowImage = type {
            nameLabel.text = nonprofit.name.uppercased()
            seeMoreButton.setTitle("SEE YOUR IMPACT", for: .normal)
        }
        causeLabel.text = nonprofit.cause?.uppercased()
        hideandseek(isEmpty: false)
        setupProgress(with: nonprofit)
        NSLayoutConstraint.deactivate(emptyConstraints)
        NSLayoutConstraint.activate(impactConstraints)
        progressBar.setNeedsLayout()
        progressBar.layoutIfNeeded()
    }
    
    func setupProgress(with impact: BKNonprofit) {
        let total = impact.totalDonations * 100
        let target = impact.targetDonations * 100
        let amtForGoal = total.truncatingRemainder(dividingBy: target)
        progressBar.numerator = amtForGoal == 0 ? target : amtForGoal
        progressBar.denominator = target
        progressBar.setNeedsLayout()
    }
    
    func setupEmptyState(with name: String?) {
        NSLayoutConstraint.deactivate(impactConstraints)
        NSLayoutConstraint.activate(emptyConstraints)
        let bundle = BeamKitContext.shared.bundle
        let image = UIImage(named: "kidbackground", in: bundle, compatibleWith: nil)
        backgroundImage.image = image
        if let name = name {
            changeButton.setTitle("See the \(name)\nCommunity Impact", for: .normal)
        }
        if case .wordsBelowImage = type {
            nameLabel.text = emptyStateTitle
            seeMoreButton.setTitle(lunchBoxTitle, for: .normal)
        }
        hideandseek(isEmpty: true)
        setNeedsLayout()
        layoutIfNeeded()
    }
        
    func hideandseek(isEmpty: Bool) {
        progressBar.isHidden = isEmpty
        if case .wordsBelowImage = type {
            backgroundImage.isHidden = isEmpty
            descriptionLabel.isHidden = !isEmpty
         //   seeMoreButton.setTitle(lunchBoxTitle, for: .normal)
            nameLabel.numberOfLines = isEmpty ? 1 : 0
        } else {
            changeButton.isHidden = !isEmpty
            nameLabel.isHidden = isEmpty
            causeLabel.isHidden = isEmpty
            seeMoreButton.isHidden = isEmpty
        }
    }
    
    public override var intrinsicContentSize: CGSize {
        var height: CGFloat = 160.0
        if case .wordsBelowImage = type {
            height = 204 + nameLabel.intrinsicContentSize.height + seeMoreButton.intrinsicContentSize.height
            if !descriptionLabel.isHidden {
                height = 60 + nameLabel.intrinsicContentSize.height +
                    descriptionLabel.intrinsicContentSize.height +  seeMoreButton.intrinsicContentSize.height
            }
        }
        return CGSize(width: superview?.bounds.width ?? 0, height: height)
    }
    
    func listen() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(donationsUpdate),
                                               name: ._bkdidCompleteTransaction,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(userRegistration),
                                               name: ._userRegistrationEvent,
                                               object: nil)
    }
}

extension BKImpactView {
    @objc
    func seeMore() {
        // TODO error out in dev mode if no delegate
        // possibly on redraw remove button if no delgate????
        guard let delegate = delegate else { return }
     //   flow.showFullImpact(from: delegate.baseViewController)
        flow.showInstacartImpact(with: nil, from: delegate.baseViewController)
    }
    
    @objc
    func seeGlobal() {
        guard let delegate = delegate else { return }
       // flow.showJustCommunityImpact(from: delegate.baseViewController)
        flow.showInstacartImpact(with: nil, from: delegate.baseViewController)

    }
    
    @objc
    func seeEither() {
        guard let delegate = delegate else { return }
        if descriptionLabel.isHidden {
            seeMore()
        } else {
            flow.showJustCommunityImpact(from: delegate.baseViewController)
        }
    }
    
    @objc
    func donationsUpdate() {
        loadImpact(forceReload: true)
    }
    
    @objc
    func userRegistration() {
        flow.context.clearImpact()
        loadImpact(forceReload: true)
    }
}


