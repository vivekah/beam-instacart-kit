//
//  BK_INSImpactVC.swift
//  BeamKit
//
//  Created by ALEXANDRA SALVATORE on 10/16/21.
//

import UIKit

public protocol BK_INSImpactVCDelegate: AnyObject {
    func didDismiss()
    func didRequestToSelectNonprofit()
    func didRequestToViewNationalImpact()
}

public class BK_INSImpactVC: UIViewController {
    weak var flow: BKImpactFlow?
    weak var context: BKImpactContext?
    weak var delegate: BK_INSImpactVCDelegate?
    
    let scrollView: UIScrollView = .init(frame: .zero)
    let contentView: UIView = .init(frame: .zero)
    // personal impact
    let personal: BK_INSPersonalImpactView = .init(frame: .zero)
    // sep bar
    let separatorfirst: UIView = .init(with: .instacartBorderGrey)
    // tutorial header
    var complianceView: BK_INSToolTip?

    private let titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textAlignment = .center
        label.numberOfLines = 2
        label.backgroundColor = .clear
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 1
        label.lineBreakMode = .byWordWrapping
        label.textColor = .instacartTitleGrey
        label.text = "Turn your groceries into good"
        label.font = .beamBold(size: 31)
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
        label.lineBreakMode = .byWordWrapping
        label.textColor = .instacartDescriptionGrey
        label.text = "This holiday season, Instacart has partnered with 4 non-profits in support of our mission to create a world where everyone has access to the food they love and more time to enjoy it together."
        return label
    }()
    // tutorial
    
    let tutorial: BK_INSTutorialVC = .init(transitionStyle: .scroll, navigationOrientation: .horizontal)
    // sep bar
    let separatorSecond: UIView = .init(with: .instacartBorderGrey)

    // compliance + powered by
    let poweredByLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = .beamRegular(size: 10)
        label.textAlignment = .right
        label.numberOfLines = 0
        label.backgroundColor = .clear
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.6
        label.text = "Powered by Beam Impact"
        label.textColor = .instacartDescriptionGrey
        return label
    }()
    
    let learnMoreLabel: UIButton = {
        let label = UIButton(frame: .zero)
        label.titleLabel?.font = .beamRegular(size: 10)
        label.backgroundColor = .clear
        label.titleLabel?.textColor = .instacartDescriptionGrey
        if let image = BeamKitContext.informationImage {
            label.setImage(image, for: .normal)
        }
        label.setTitleColor(.instacartDescriptionGrey, for: .normal)
        label.titleEdgeInsets = .init(top: 0, left: 10, bottom: 0, right: 0)
        label.setTitle("Learn More", for: .normal)
        label.titleLabel?.textAlignment = .left
        label.contentHorizontalAlignment = .left
        return label
    }()
    
    
    // title
    // description
    // natl linklll
    let cumulative: BK_INSCumulativeImpactView = .init(frame: .zero)
    
    let separatorThird: UIView = .init(with: .instacartBorderGrey)

    // title
    private let communityImpactTitleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textAlignment = .center
        label.numberOfLines = 1
        label.backgroundColor = .clear
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 1
        label.textColor = .instacartTitleGrey
        label.text = "Impact in your area"
        label.font = .beamBold(size: 18)
        return label
    }()
    // impact titles
    let tile: BK_INSCommunityTile = .init(frame: .zero)
    let tile1: BK_INSCommunityTile = .init(frame: .zero)
    let tile2: BK_INSCommunityTile = .init(frame: .zero)
    let tile3: BK_INSCommunityTile = .init(frame: .zero)
    let tile4: BK_INSCommunityTile = .init(frame: .zero)
    var loadManually: Bool = false

    let tableView = UITableView(frame: .zero, style: .plain)
    
    let disclosureLabel: UILabel = {
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

    var tileHeightConstraints: [NSLayoutConstraint] = [NSLayoutConstraint]()
    var tileContentView: UIView = .init(with: .white)
    var isSetup = false
    
    init(context: BKImpactContext,
         flow: BKImpactFlow,
         delegate: BK_INSImpactVCDelegate?) {
        self.context = context
        self.flow = flow
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
        listen()
    }
    
    public init(flow: BKImpactFlow,
         delegate: BK_INSImpactVCDelegate?) {
        self.context = BeamKitContext.shared.impactContext
        self.flow = flow
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
        loadManually = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func loadView() {
        view = scrollView
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func setup() {
        view.backgroundColor = .white
        contentView.backgroundColor = .white
        view.addSubview(contentView.usingConstraints())
        contentView.addSubview(personal.usingConstraints())
        contentView.addSubview(separatorfirst.usingConstraints())
        contentView.addSubview(titleLabel.usingConstraints())
        contentView.addSubview(subLabel.usingConstraints())
        contentView.addSubview(separatorSecond.usingConstraints())
        contentView.addSubview(learnMoreLabel.usingConstraints())
        contentView.addSubview(poweredByLabel.usingConstraints())
        contentView.addSubview(cumulative.usingConstraints())
        contentView.addSubview(separatorThird.usingConstraints())
        contentView.addSubview(communityImpactTitleLabel.usingConstraints())
        contentView.addSubview(tileContentView.usingConstraints())
        tileContentView.addSubview(tile.usingConstraints())
        tileContentView.addSubview(tile1.usingConstraints())
        tileContentView.addSubview(tile2.usingConstraints())
        tileContentView.addSubview(tile3.usingConstraints())
        tileContentView.addSubview(tile4.usingConstraints())
        contentView.addSubview(disclosureLabel.usingConstraints())

        addChild(tutorial)
        contentView.addSubview(tutorial.view.usingConstraints())
        tutorial.didMove(toParent: self)
        cumulative.delegate = delegate
        personal.delegate = self
        learnMoreLabel.addTarget(self, action: #selector(showComplianceView), for: .touchUpInside)
        setupConstraints()
        isSetup = true
        if loadManually {
            impactDidLoad()
        }
    }
    
    func setupConstraints() {
        let views: Views = ["content": contentView,
                            "title": titleLabel,
                            "sub": subLabel,
                            "personal": personal,
                            "tutorial": tutorial.view,
                            "learn": learnMoreLabel,
                            "powered": poweredByLabel,
                            "cum": cumulative,
                            "commTitle": communityImpactTitleLabel,
                            "tile": tileContentView,
                            "disclosure": disclosureLabel,
                            "sep1": separatorfirst,
                            "sep2": separatorSecond,
                            "sep3": separatorThird]
        
        let isBig = UIDevice.current.hasNotch || UIDevice.current.isPlus
        let tutorialHeight = isBig ? 430 : 373
        let titleMargin = isBig ? 20 : 30
        let subMargin = isBig ? 32 : 20
        let metrics: [String: Int] = ["tutorial": tutorialHeight,
                                      "subM": subMargin,
                                      "titleM": titleMargin]
        
        let formats: [String] = ["H:|[content]|",
                                 "V:|[content]|",
                                 "V:|[personal]-[sep1(1)]-10-[title]-10-[sub]-32-[tutorial(tutorial)]-[sep2(1)]-[learn]-12-[cum]-12-[sep3(1)]-12-[commTitle]-12-[tile]-16-[disclosure]-|",
                                 "V:[sep2]-[powered]",
                                 "H:|[personal]|",
                                 "H:|-16-[sep1]-16-|",
                                 "H:|[tutorial]|",
                                 "H:|-16-[learn(100)]-[powered]-16-|",
                                 "H:|-subM-[sub]-subM-|",
                                 "H:|-16-[sep2]-16-|",
                                 "H:|-titleM-[title]-titleM-|",
                                 "H:|-16-[commTitle]-16-|",
                                 "H:|-16-[disclosure]-16-|",
                                 "H:|-40-[sep3]-40-|",
                                 "H:|-16-[tile]-16-|",
                                 "H:|[cum]|",

        ]
        var constraints = NSLayoutConstraint.constraints(withFormats: formats,
                                                         options: [],
                                                         metrics: metrics,
                                                         views: views)
        let height = NSLayoutConstraint(item: contentView,
                                        attribute: .height,
                                        relatedBy: .equal,
                                        toItem: view,
                                        attribute: .height,
                                        multiplier: 1.0,
                                        constant: 0)
        height.priority = .defaultLow
        constraints += [ NSLayoutConstraint(item: contentView,
                                            attribute: .width,
                                            relatedBy: .equal,
                                            toItem: view,
                                            attribute: .width,
                                            multiplier: 1.0,
                                            constant: 0),
                         height
                         
        ]
    
        NSLayoutConstraint.activate(constraints)
    }
    
    func listen() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(impactDidLoad),
                                               name: ._bkDidUpdateCommunityImpact,
                                               object: nil)
    }
    
    @objc
    func showComplianceView() {
        if complianceView != nil {
            complianceView?.toggleShow()
        } else {
            var complianceString = "To support local nonprofits across the country, donations are made to PayPal Giving Fund, a registered 501(c)(3) nonprofit organization. PPGF receives the donation and distributes 100% to the nonprofit of your choice, with Instacart covering all applicable processing fees. In the extremely rare event your nonprofit shuts down or PPGF is otherwise unable to fund it, PPGF will reassign the funds to a similar nonprofit in your area."
            if let context = self.context,
               let impact = context.instacartImpact,
               let comp = impact.copy.complianceDescription {
                complianceString = comp
            }
            complianceView = BK_INSToolTip(text: complianceString, tipPos: .left)
            guard let cv = complianceView else { return }
            cv.isHidden = true
            view.addSubview(cv.usingConstraints())
            cv.topAnchor.constraint(equalTo: learnMoreLabel.bottomAnchor, constant: 1).isActive = true
            cv.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
            cv.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
            //cv.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.6).isActive = true

            cv.performShow()
        }
    }
    
    func scrollToResults() {
        let scrollPoint = CGPoint(x: 0, y: separatorThird.frame.origin.y)
        scrollView.setContentOffset(scrollPoint, animated: true)
    }
    
    @objc
    func requestToShowSelection() {
        delegate?.didRequestToSelectNonprofit()
    }
}


extension BK_INSImpactVC {
    @objc
    func impactDidLoad() {
        if !isSetup {
            loadManually = true
            return
        }
        DispatchQueue.main.async {
            guard let context = self.context,
                let impact = context.instacartImpact else { return }

            self.configureTiles(with: impact)
            self.titleLabel.text = impact.copy.title
            self.communityImpactTitleLabel.text = impact.copy.communityImpactTitle
            self.personal.configure(with: impact)
            self.cumulative.configure(with: impact)
            self.tutorial.configure(with: impact)
            
            if let sub = impact.copy.subtitle {
                self.subLabel.text = sub
                let style = NSMutableParagraphStyle()
                style.lineHeightMultiple = 1.1
                style.alignment = .center
                if let attrString = sub.bkhtmlAttributedString(with: 15)?.mutableCopy() as? NSMutableAttributedString {
                    let nsstring = NSString(string: attrString.string)
                    let range = NSMakeRange(0, nsstring.length)
                    attrString.addAttribute(.paragraphStyle, value: style, range: range)
                    attrString.addAttribute(.foregroundColor, value: UIColor.instacartDescriptionGrey.cgColor, range: range)
                    self.subLabel.attributedText = attrString
                }
            }
            
            if let title = impact.copy.title {
                self.titleLabel.text = title
            }
            
            self.disclosureLabel.text = impact.copy.instacartDisclosure ?? "Offer applies to all orders placed between 11/30/21 12:00 AM PST and 12/8/21 12:00 AM PST. The cost of a meal varies by nonprofit. The nonprofit you choose will receive at least $1 for every 10 meals donated. You must choose a nonprofit before placing your order. Your chosen nonprofit will be your default for all orders during offer period. Does not apply to orders that are canceled or fully refunded."
        }
    }
    
    func configureTiles(with impact: BK_INSImpact) {
        let tiles = [self.tile, self.tile1, self.tile2, self.tile3, self.tile4]
        let nonprofitNumber = impact.nonprofits.count
        for (i, nonprofit) in impact.nonprofits.enumerated() {
            if i < tiles.count {
                let tile = tiles[i]
                tile.isHidden = false
                tile.configure(with: nonprofit)
                tile.ctaButton.addTarget(self, action: #selector(self.requestToShowSelection), for: .touchUpInside)
            }
        }
        if nonprofitNumber < tiles.count {
            var i = nonprofitNumber
            while i < tiles.count {
                let tile = tiles[i]
                tile.isHidden = true
                i += 1
            }
        }
        NSLayoutConstraint.deactivate(tileHeightConstraints)
        let tileViews: Views =  ["tile": tile,
                                 "tile1": tile1,
                                 "tile2": tile2,
                                 "tile3": tile3,
                                 "tile4": tile4]
        var formats: [String] = ["H:|[tile]|",
                                 "H:|[tile1]|",
                                 "H:|[tile2]|",
                                 "H:|[tile3]|"]
        if nonprofitNumber == 4 {
            formats += ["V:|[tile]-[tile1]-[tile2]-[tile3]|"]
        } else if nonprofitNumber == 3 {
            formats += ["V:|[tile]-[tile1]-[tile2]|"]
        } else if nonprofitNumber == 5 {
            formats += ["V:|[tile]-[tile1]-[tile2]-[tile3]-[tile4]-|"]
        } else if nonprofitNumber == 2 {
            formats += ["V:|[tile]-[tile1]|"]
        }
        
        tileHeightConstraints = NSLayoutConstraint.constraints(withFormats: formats,
                                                               options: [],
                                                               metrics: [:],
                                                               views: tileViews)
        NSLayoutConstraint.activate(tileHeightConstraints)
        view.setNeedsLayout()
    }
}


extension BK_INSImpactVC: BK_INSPersonalImpactDelegate {
    public func didSelectButton(with favorite: String?) {
        if favorite != nil {
            scrollToResults()
        } else {
            delegate?.didRequestToSelectNonprofit()
        }
    }

}
