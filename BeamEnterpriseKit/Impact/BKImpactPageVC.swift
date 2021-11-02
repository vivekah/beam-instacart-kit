//
//  BKImpactPageVC.swift
//  BeamKit
//
//  Created by ALEXANDRA SALVATORE on 10/29/19.
//  Copyright © 2020 Beam Impact. All rights reserved.
//

import UIKit

protocol BKImpactPageDelegate: class {
    func didSwipeToGlobal()
    func didSwipeToImpact()
}

class BKImpactPageVC: UIPageViewController {
    var flow: BKImpactFlow? = nil {
        didSet {
            setupViews()
        }
    }
    
    weak var impactDelegate: BKImpactPageDelegate?
    
    override init(transitionStyle style: UIPageViewController.TransitionStyle, navigationOrientation: UIPageViewController.NavigationOrientation, options: [UIPageViewController.OptionsKey : Any]? = nil) {
        super.init(transitionStyle: .scroll,
                   navigationOrientation: .horizontal,
                   options: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        delegate = self
        view.backgroundColor = .white
        setupViews()
    }
    
    func setupViews() {
        if let flow = flow {
            setViewControllers([flow.currentView],
                               direction: .forward,
                               animated: true,
                               completion: nil)
        }
    }
}

extension BKImpactPageVC: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController,
                            didFinishAnimating finished: Bool,
                            previousViewControllers: [UIViewController],
                            transitionCompleted completed: Bool) {
        guard completed else { return }
        if let _ = previousViewControllers.first as? BKImpactVC,
            let _ = pageViewController.viewControllers?.first as? BKCommunityImpactVC {
            impactDelegate?.didSwipeToGlobal()
        } else if let _ = previousViewControllers.first as? BKCommunityImpactVC,
            let _ = pageViewController.viewControllers?.first as? BKImpactVC {
            impactDelegate?.didSwipeToImpact()
        }
    }
}

extension BKImpactPageVC: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) ->
        UIViewController? {
            return flow?.vc(before: viewController)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) ->
        UIViewController? {
            return flow?.vc(after: viewController)
    }
}

