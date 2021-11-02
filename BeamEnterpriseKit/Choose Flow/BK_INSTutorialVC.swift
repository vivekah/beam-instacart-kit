//
//  BK_INSTutorialVC.swift
//  BeamKit
//
//  Created by ALEXANDRA SALVATORE on 10/27/21.
//

import UIKit

class BK_INSTutorialVC: UIPageViewController {
    let vc1 = BK_INSTutorialSlideVC.init(nibName: nil, bundle: nil)
    let vc2 = BK_INSTutorialSlideVC.init(nibName: nil, bundle: nil)
    let vc3 = BK_INSTutorialSlideVC.init(nibName: nil, bundle: nil)
    lazy var carousel = [vc1, vc2, vc3]
    let pageControl = UIPageControl.appearance(whenContainedInInstancesOf: [BK_INSTutorialVC.self])

   // lazy var tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTap))

    override init(transitionStyle style: UIPageViewController.TransitionStyle,
                  navigationOrientation: UIPageViewController.NavigationOrientation,
                  options: [UIPageViewController.OptionsKey : Any]? = nil) {
        super.init(transitionStyle: .scroll,
                   navigationOrientation: .horizontal,
                   options: options)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        delegate = self
        setupViews()
    }
    
    func setupViews() {
            setViewControllers([vc1],
                               direction: .forward,
                               animated: true,
                               completion: nil)
        vc1.configure(title: "Fight food insecurity with every order", description: "With every Instacart order this week, 1 meal will be donated to a food bank you choose, at no extra cost to you.")
        vc2.configure(title: "Choose your food bank", description: "Favorite a food bank fighting insecurity, for communities near you or across the country.")
        vc3.configure(title: "Fill plates with every order", description: "Every time you place an order like normal, 1 meal will be donated to your food bank. Watch your impact grow in Settings. That’s it- no roundups and no extra cost to you.")
        pageControl.pageIndicatorTintColor = .instacartDisableGrey
        pageControl.currentPageIndicatorTintColor = .instacartTitleGrey
        pageControl.numberOfPages = 3
       // navigationController?.setNavigationBarHidden(true, animated: true)
        
        let topPadding: CGFloat = UIDevice.current.is6OrSmaller ? 20 : 50
      //  view.addSubview(pageControl.usingConstraints())
        pageControl.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: topPadding).isActive = true
        pageControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        pageControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        pageControl.heightAnchor.constraint(equalToConstant: 8).isActive = true
        view.bringSubviewToFront(pageControl)
    }
    
    func configure(with impact: BK_INSImpact) {
        let tutorial = impact.copy.tutorial
        let slides = [vc1, vc2, vc3]
        for (i, copy) in tutorial.enumerated() {
            slides[i].configure(copy)
        }
    }
}

extension BK_INSTutorialVC: UIPageViewControllerDataSource {
    
    
       func vc(before: UIViewController) -> UIViewController? {
           var prevIndex = -1
        for (i, vc) in [(0, vc1), (1, vc2), (2, vc3)] {
               if vc == before {
                   prevIndex = i - 1
               }
           }
           
           guard prevIndex >= 0, prevIndex < carousel.count else { return nil }
           return carousel[prevIndex]
       }
       
       func vc(after: UIViewController) -> UIViewController? {
           var nextIndex = -1
        for (i, vc) in [(0, vc1), (1, vc2), (2, vc3)] {
               if vc == after {
                   nextIndex = i + 1
               }
           }
           
           guard nextIndex >= 0, nextIndex < carousel.count else { return nil }
           return carousel[nextIndex]
       }

    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) ->
        UIViewController? {
        return vc(before: viewController)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) ->
        UIViewController? {
          return vc(after: viewController)
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return 3
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
       // guard let flow = flow else { return 0 }
        for (i, vc) in [(0, vc1), (1, vc2), (2, vc3)] {
            if pageViewController == vc {
                return i
            }
        }
        return 0
    }
    //021622    
    public
    func goForward(from: UIViewController) -> Bool  {
        guard let vc = vc(after: from) else { return false }
        setViewControllers([vc],
                                  direction: .forward,
                                  animated: true,
                                  completion: nil)
        return true
    }
}

extension BK_INSTutorialVC: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
//        pageControl.subviews.forEach {
//            $0.transform = CGAffineTransform(scaleX: 1, y: 1)
//        }
//
//        // transform the scale of the current subview dot, adjust the scale as required, but bigger the scale value, the downward the dots goes from its centre.
//        // You can adjust the centre anchor of the selected dot to keep it in place approximately.
//
//        self.pageControl.subviews[self.pageControl.currentPage].transform = CGAffineTransform(scaleX: 1.25, y: 1.25)
        
    }
}

public class BK_INSTutorialSlideVC: UIViewController {
    let nonprofitImage: UIImageView = {
        let view = UIImageView(frame: .zero)
        view.backgroundColor = .instacartDisableGrey
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.backgroundColor = .clear
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 1
        label.text = "Together we’ve funded 27,571 meals nationwide"
        label.textColor = .instacartTitleGrey
        label.font = .beamBold(size: 18)
        return label
    }()
    
    let subLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.beamRegular(size: 12)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.backgroundColor = .clear
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 1
        label.text = "We’ve partnered with hundreds of local and national charities. "
        label.textColor = .instacartTitleGrey
        return label
    }()
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        nonprofitImage.layer.cornerRadius = 12
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func configure(title: String, description: String) {
        titleLabel.text = title
        subLabel.text = description
    }
    
    func configure(_ slide: BK_INSTutorialCopy) {
        titleLabel.text = slide.title
        subLabel.text = slide.subtitle
        if let image = slide.image,
           let imageURL = URL(string: image) {
               nonprofitImage.bkSetImageWithUrl(imageURL)
        }
    }
    
    func setup() {
        view.backgroundColor = .white
        view.addSubview(titleLabel.usingConstraints())
        view.addSubview(subLabel.usingConstraints())
        view.addSubview(nonprofitImage.usingConstraints())
        
        setupConstraints()
    }
    
    func setupConstraints() {
        let views: Views = ["title": titleLabel,
                            "sub": subLabel,
                            "img": nonprofitImage]
        
        let formats: [String] = ["V:|[img(160)]-[title]-[sub]->=1-|",
                                 "H:|-20-[sub]-20-|",
                                 "H:|-16-[title]-16-|",
                                 "H:|-16-[img]-16-|",

        ]
        let constraints = NSLayoutConstraint.constraints(withFormats: formats,
                                                         options: [],
                                                         metrics: nil,
                                                         views: views)
    
        NSLayoutConstraint.activate(constraints)
    }
}
