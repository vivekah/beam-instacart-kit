//
//  BK_INSChooseNonprofitVC.swift
//  BeamKit
//
//  Created by ALEXANDRA SALVATORE on 10/16/21.
//

import UIKit

public protocol BK_INSChooseNonprofitVCDelegate: class {
    func didDismiss()
    
    func didRequestToLearnMore()
}

public class BK_INSChooseNonprofitVC: UIViewController {

    let transaction: BKTransaction
    var flow: BKChooseNonprofitFlow {
        return BeamKitContext.shared.chooseFlow
    }
    
    let scrollView: UIScrollView = .init(frame: .zero)
    let contentView: UIView = .init(frame: .zero)
    let header: BK_INSVisitHeaderView
    public weak var delegate: BK_INSChooseNonprofitVCDelegate?

    let first: BK_INSNonprofitButton = .init(frame: .zero)
    let second: BK_INSNonprofitButton = .init(frame: .zero)
    let third: BK_INSNonprofitButton = .init(frame: .zero)
    let fourth: BK_INSNonprofitButton = .init(frame: .zero)
    var showFourth: Bool = true
    let footer: BK_INSVisitFooterView = .init(frame: .zero)
    var selectedNonprofit: BK_INSNonprofitButton? = nil
    let placeholder: UIView = .init(frame: .zero)
    var complianceView: BK_INSToolTip?

    init(with transaction: BKTransaction) {
        self.transaction = transaction
        header = BK_INSVisitHeaderView(with: transaction)
        super.init(nibName: nil, bundle: nil)
    }
    
    public class func new() -> BK_INSChooseNonprofitVC? {
        guard let trans = BeamKitContext.shared.chooseFlow.context.currentTransaction else { return nil }
        return BK_INSChooseNonprofitVC.init(with: trans)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func setup() {
        view.backgroundColor = .white
        view.addSubview(scrollView.usingConstraints())
        scrollView.addSubview(contentView.usingConstraints())
        contentView.addSubview(header.usingConstraints())
        contentView.addSubview(first.usingConstraints())
        contentView.addSubview(second.usingConstraints())
        contentView.addSubview(third.usingConstraints())
        contentView.addSubview(fourth.usingConstraints())
        contentView.addSubview(placeholder.usingConstraints())
        placeholder.backgroundColor = .white
        view.addSubview(footer.usingConstraints())
        if let cta = transaction.storeNon.cta {
            footer.selectButton.setTitle(cta, for: .normal)
        }
        configureNonprofits()
        addTargets()
        setupConstraints()
        
        header.showComplianceView = showComplianceView
        header.descriptionLabel.addTarget(self, action: #selector(didSelectSubhead), for: .touchUpInside)
    }
    
    func configureNonprofits() {
        guard let nonprofits = transaction.storeNon.nonprofits else { return }
        let selected = transaction.storeNon.lastNonprofit?.id ?? 0
        BeamKitContext.shared.saveNonprofit(id: selected)

        let firstNon = nonprofits.count > 0 ? nonprofits[0] : nil
        first.configure(with: firstNon)
        if selected == firstNon?.id {
            selectedNonprofit = first
            first.makeSelected()
            footer.toggle(on: true)
        }
        let secondNon = nonprofits.count > 1 ? nonprofits[1] : nil
        second.configure(with: secondNon)
        if selected == secondNon?.id {
            selectedNonprofit = second
            second.makeSelected()
            footer.toggle(on: true)
        }
        let thirdNon = nonprofits.count > 2 ? nonprofits[2] : nil
        third.configure(with: thirdNon)
        if selected == thirdNon?.id {
            selectedNonprofit = third
            third.makeSelected()
            footer.toggle(on: true)
        }
        let fourthNon = nonprofits.count > 3 ? nonprofits[3] : nil
        fourth.configure(with: fourthNon)
        if selected == fourthNon?.id {
            selectedNonprofit = fourth
            fourth.makeSelected()
            footer.toggle(on: true)
        }
        showFourth = !fourth.isHidden
        
     
    }
    
    func setupConstraints() {
        let views: Views = ["header": header,
                            "content": contentView,
                            "scroll": scrollView,
                            "first": first,
                            "second": second,
                            "third": third,
                            "fourth": fourth,
                            "buffer": placeholder,
                            "footer": footer]
        
        var formats: [String] = ["V:|[scroll]|",
                                 "H:|[scroll]|",
                                 "V:|[content]|",
                                 "H:|[content]|",
                                 "H:|[header]|",
                                 "H:|[footer]|",
                                 "V:[footer]|",
                                 "H:|-16-[buffer]-16-|",
                                 "H:|-16-[first]-16-|",
                                 "H:|-16-[second]-16-|",
                                 "H:|-16-[third]-16-|",
                                 "H:|-16-[fourth]-16-|"]
        var insets: CGFloat = 0
        
        if #available(iOS 11.0, *) {
            insets = UIApplication.shared.keyWindow?.safeAreaInsets.top ?? 8
        }
        let metrics = ["top": insets,
                       "height": 150]
        
        if showFourth {
            formats.append("V:|-top-[header]-12-[first(height)]-8-[second(height)]-8-[third(height)]-8-[fourth(height)][buffer(100)]|")
        } else {
            formats.append("V:|-top-[header]-12-[first(height)]-8-[second(height)]-8-[third(height)][buffer(100)]|")
        }
        
        var constraints: Constraints = NSLayoutConstraint.constraints(withFormats: formats,
                                                                      metrics: metrics,
                                                                      views: views)
        let buttonHeight = UIDevice.current.hasNotch ? 80 : UIDevice.current.isPlus ? 54 : 40

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
                         height,
                         NSLayoutConstraint(item: footer,
                                            attribute: .height,
                                            relatedBy: .equal,
                                            toItem: nil,
                                            attribute: .notAnAttribute,
                                            multiplier: 1,
                                            constant: footer.selectButton.intrinsicContentSize.height + CGFloat(buttonHeight))
                         
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
}

extension BK_INSChooseNonprofitVC {
    
    func addTargets() {
         header.backButton.addTarget(self,
                                    action: #selector(didTapBackButton),
                                    for: .touchUpInside)
        first.delegate = self
        second.delegate = self
        third.delegate = self
        fourth.delegate = self
        
        footer.selectButton.addTarget(self,
                                      action: #selector(didTapChooseButton),
                                      for: .touchUpInside)
    }
    
    @objc
    func didTapBackButton() {
        flow.navigateBack(from: self)
    }
    
    func showComplianceView() {
        if complianceView != nil {
            complianceView?.toggleShow()
        } else {
            let complianceString = transaction.storeNon.complianceDescription ?? "To support local nonprofits across the country, donations are made to PayPal Giving Fund, a registered 501(c)(3) nonprofit organization. PPGF receives the donation and distributes 100% to the nonprofit of your choice, with Instacart covering all applicable processing fees. In the extremely rare event your nonprofit shuts down or PPGF is otherwise unable to fund it, PPGF will reassign the funds to a similar nonprofit in your area."
            complianceView = BK_INSToolTip(text: complianceString, tipPos: .left)
            guard let cv = complianceView else { return }
            cv.isHidden = true
            view.addSubview(cv.usingConstraints())
            cv.topAnchor.constraint(equalTo: header.bottomAnchor, constant: 1).isActive = true
            cv.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
            cv.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true

            cv.performShow()
        }
    }
    
    @objc func didSelectSubhead() {
        delegate?.didRequestToLearnMore()
    }
}

extension BK_INSChooseNonprofitVC: BK_INSNonprofitButtonDelegate {
    
    func didSelect(_ nonprofit: BKNonprofit?, button: BK_INSNonprofitButton) {
        guard let _ = nonprofit else {
            flow.navigateBack(from: self)
            return
        }
        // turn off user interaction so doesn't call api twice
        // view.isUserInteractionEnabled = false
        selectedNonprofit?.deslect()
        selectedNonprofit = button
        button.makeSelected()
        footer.toggle(on: true)
    }
    
    @objc
    func didTapChooseButton() {
        guard let nonprofit = selectedNonprofit?.nonprofit else { return }
        flow.favorite(nonprofit: nonprofit, from: self) {
            BeamKitContext.shared.saveNonprofit(id: nonprofit.id)
            BeamKitContext.shared.saveNonprofit(name: nonprofit.name)
        }
    }
}

class BK_INSVisitHeaderView: UIView {
    let transaction: BKTransaction
    fileprivate let backButton: BKBackButton = .init(frame: .zero)
    
    let navBarView: UIView = .init(with: .white)
    
    let titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = .beamBold(size: 31)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.backgroundColor = .clear
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.6
        label.lineBreakMode = .byWordWrapping
        label.textColor = .instacartTitleGrey
        return label
    }()
    
    let descriptionLabel: UIButton = {
        let label = UIButton(frame: .zero)
        label.titleLabel?.font = .beamRegular(size: 30)
        label.backgroundColor = .clear
        label.titleLabel?.textColor = .instacartDescriptionGrey
        label.titleLabel?.lineBreakMode = .byWordWrapping
        label.titleLabel?.numberOfLines = 3
        label.titleLabel?.textAlignment = .left
        label.contentHorizontalAlignment = .left
        return label
    }()
    
    let poweredByLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = .beamRegular(size: 10)
        label.textAlignment = .right
        label.numberOfLines = 1
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
        label.titleEdgeInsets = .init(top: 0, left: 5, bottom: 0, right: 0)
        label.setTitle("Learn More", for: .normal)
        label.titleLabel?.textAlignment = .left
        label.contentHorizontalAlignment = .left
        return label
    }()
    
    var showComplianceView: (() -> Void)? = nil
    
    init(with transaction: BKTransaction) {
        self.transaction = transaction
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        if let complianceCTA = transaction.storeNon.complianceCTA {
            learnMoreLabel.setTitle(complianceCTA, for: .normal)
        }
        addSubview(descriptionLabel.usingConstraints())
        addSubview(titleLabel.usingConstraints())
        addSubview(poweredByLabel.usingConstraints())
        addSubview(learnMoreLabel.usingConstraints())
        
        learnMoreLabel.addTarget(self, action: #selector(didTapLearnMore), for: .touchUpInside)
        setupConstraints()
        
        let sub = transaction.storeNon.subtitle
        descriptionLabel.setTitle(sub, for: .normal)
        descriptionLabel.sizeToFit()

        
        let style = NSMutableParagraphStyle()
        style.lineHeightMultiple = 1.25
        
        if let sub = sub,
           let attrString = sub.bkhtmlAttributedString(with: 15)?.mutableCopy() as? NSMutableAttributedString {
            let nsstring = NSString(string: attrString.string)
            let range = NSMakeRange(0, nsstring.length)
            attrString.addAttribute(.paragraphStyle, value: style, range: range)
            descriptionLabel.setAttributedTitle(attrString, for: .normal)
        }
        
        if let title = transaction.storeNon.title  {
            titleLabel.text = title
            let newstyle = NSMutableParagraphStyle()
            newstyle.lineHeightMultiple = 1.1
            let attributedString = NSAttributedString(string: title, attributes: [NSAttributedString.Key.paragraphStyle: newstyle])
            titleLabel.attributedText = attributedString
        }
    }

    
    func setupConstraints() {
        let insets = UIEdgeInsets.zero
        let views: Views = ["title": titleLabel,
                            "desc": descriptionLabel,
                            "poweredBy": poweredByLabel,
                            "learnMore": learnMoreLabel]
            
        let metrics: [String: Any] = ["navHeight": UIView.beamDefaultNavBarHeight,
                                      "top": insets.top,
                                      "pad": 5]
        
        let formats: [String] = ["V:|-5-[title]-[desc(70)]-10-[poweredBy]|",
                                 "V:[desc]-10-[learnMore]|",
                                 "H:|-16-[learnMore(100)]->=7-[poweredBy(150)]-16-|",
                                 "H:|-16-[title]-16-|",
                                 "H:|-16-[desc]-16-|"]
        
        var constraints = NSLayoutConstraint.constraints(withFormats: formats,
                                                      options: [],
                                                      metrics: metrics,
                                                      views: views)
        constraints += [
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    override var intrinsicContentSize: CGSize {
        let width = bounds.width
        let height = UIView.beamDefaultNavBarHeight * 2 + 5
        return CGSize(width: width, height: height)
    }

}

extension BK_INSVisitHeaderView {
    @objc
    func didTapLearnMore() {
        showComplianceView?()
    }

}


class BK_INSVisitFooterView: UIView {
    var isDisabled: Bool = true
    
    public let selectButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.titleLabel?.textAlignment = .center
        button.backgroundColor = .instacartDisableGrey
        button.titleLabel?.font = .beamSemiBold(size: 15)
        button.setTitleColor(.instacartDescriptionGrey, for: .normal)
        button.setTitle("Choose nonprofit", for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        selectButton.layer.cornerRadius = 5
    }
    
    func setup() {
        backgroundColor = .white
        addSubview(selectButton.usingConstraints())
        setupConstraints()
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        layer.shadowColor = UIColor.instacartDescriptionGrey.cgColor
        layer.shadowRadius = 9
        layer.shadowOffset = .zero
        layer.shadowOpacity = 1
    }
    
    func setupConstraints() {
        let views: Views = ["button": selectButton]
        
        let formats: [String] = ["H:|-[button]-|",
                                 "V:|-[button]-|"]
    
        let constraints = NSLayoutConstraint.constraints(withFormats: formats,
                                                         options: [],
                                                         metrics: nil,
                                                         views: views)
    
        NSLayoutConstraint.activate(constraints)
    }
    
    public func toggle(on: Bool) {
        selectButton.isEnabled = on
        selectButton.backgroundColor = on ? .instacartGreen : .instacartDisableGrey
        let titleColor: UIColor = on ? .white : .instacartDescriptionGrey
        selectButton.setTitleColor(titleColor, for: .normal)
        isDisabled = !on
    }
}

