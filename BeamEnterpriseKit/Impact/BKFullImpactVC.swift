//
//  BKFullImpactVC.swift
//  BeamKit
//
//  Created by ALEXANDRA SALVATORE on 10/29/19.
//  Copyright © 2020 Beam Impact. All rights reserved.
//

import UIKit

class BKFullImpactVC: UIViewController {
    weak var flow: BKImpactFlow?
    weak var context: BKImpactContext?
    
    let navBar: BKNavBarView = .init(frame: .zero)
    
    let tabBar: BKImpactSlideView = .init(frame: .zero)
    let carousel: BKImpactPageVC = .init(transitionStyle: .scroll,
                                         navigationOrientation: .horizontal)
    
    init(context: BKImpactContext,
         flow: BKImpactFlow,
         shownFromWidget: Bool = true) {
        self.context = context
        self.flow = flow
        super.init(nibName: nil, bundle: nil)
        if !shownFromWidget {
            context.loadImpact()
            context.loadCommunityImpact()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navBar.setNeedsLayout()
        navBar.layoutIfNeeded()
        if let logo = context?.impact?.logo,
            let url = URL(string: logo) {
            navBar.update(with: url)
        }
    }
        
    func setup() {
        view.isUserInteractionEnabled = true
        view.backgroundColor = .white
        view.addSubview(navBar.usingConstraints())
        view.addSubview(tabBar.usingConstraints())
        navBar.backButton.addTarget(self, action: #selector(navigateBack), for: .touchUpInside)
        addChild(carousel)
        view.addSubview(carousel.view.usingConstraints())
        carousel.didMove(toParent: self)
        carousel.flow = flow
        carousel.impactDelegate = self
        tabBar.delegate = self
        setupConstraints()
    }
    
    func setupConstraints() {
        let views: Views = ["title": navBar,
                            "tab": tabBar,
                            "page": carousel.view]
        
        var insets: CGFloat = 8.0
    
        if #available(iOS 11.0, *) {
            insets = view.safeAreaInsets.top + 10
        }
        
        let metrics: [String: Any] = ["topInset": insets,
                                      "headerHeight": UIView.beamDefaultNavBarHeight + 20]
        
        let formats: [String] = ["V:|-topInset-[title(headerHeight)]-8-[tab]-[page]|",
                                 "H:|[title]|",
                                 "H:|-20-[tab]",
                                 "H:|[page]|",
                                 "H:|[title]|"

        ]
        var constraints: Constraints =
        NSLayoutConstraint.constraints(withFormats: formats,
                                       options: [],
                                       metrics: metrics,
                                       views: views)
        constraints += [NSLayoutConstraint.constrainWidth(tabBar, by: tabBar.intrinsicContentSize.width)]
        NSLayoutConstraint.activate(constraints)
    }
}

extension BKFullImpactVC {
    @objc
    func navigateBack() {
        flow?.didDismissFullImpact()
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        flow?.didDismissFullImpact()
    }
}

extension BKFullImpactVC: BKImpactSlideViewDelegate {
    func didSelectMyImpact() {
        guard let flow = flow else {
            // TODO config error
            return
        }
        flow.selectImpact(from: carousel)
    }
    
    func didSelectGlobal() {
        guard let flow = flow else {
            // TODO config error
            return
        }
        flow.selectCommunity(from: carousel)
    }
}

extension BKFullImpactVC: BKImpactPageDelegate {
    func didSwipeToGlobal() {
        tabBar.didSelectGlobal()
    }
    
    func didSwipeToImpact() {
        tabBar.didSelectMyImpact()
    }
}
