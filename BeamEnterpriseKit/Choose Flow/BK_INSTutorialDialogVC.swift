//
//  BK_INSTutorialDialogVC.swift
//  BeamKit
//
//  Created by ALEXANDRA SALVATORE on 10/27/21.
//

import UIKit

public class BK_INSTutorialDialogVC: UIViewController {
    let tutorial: BK_INSTutorialVC = .init(transitionStyle: .scroll, navigationOrientation: .horizontal)
    let footer: BK_INSVisitFooterView = .init(frame: .zero)

    override public func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func setup() {
        view.backgroundColor = .white
        addChild(tutorial)
        view.addSubview(tutorial.view.usingConstraints())
        tutorial.didMove(toParent: self)
        view.addSubview(footer.usingConstraints())
        footer.selectButton.addTarget(self, action: #selector(didTapFooter), for: .touchUpInside)
        footer.selectButton.setTitle("Next", for: .normal)
        footer.toggle(on: true)
        setupConstraints()
        setupNavBar()
    }
    
    func setupNavBar() {
        let navItem = UINavigationItem(title: "SomeTitle")
        let navBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 44))
        navItem.title = "How it works"
        navBar.setItems([navItem], animated: false)
        view.addSubview(navBar)
    }
    
    func setupConstraints() {
        let views: Views = ["tutorial": tutorial.view,
                            "footer": footer]
        
        let formats: [String] = ["H:|[tutorial]|",
                                 "H:|[footer]|",
                                 "V:|-70-[tutorial]-[footer(100)]|",

        ]
        let constraints = NSLayoutConstraint.constraints(withFormats: formats,
                                                         options: [],
                                                         metrics: nil,
                                                         views: views)

    
        NSLayoutConstraint.activate(constraints)
    }
}

extension BK_INSTutorialDialogVC {
    @objc
    func didTapFooter() {
        let didGo = tutorial.goForward(from: self)
        if !didGo {
            dismiss(animated: true, completion: nil)
        }
    }
}
