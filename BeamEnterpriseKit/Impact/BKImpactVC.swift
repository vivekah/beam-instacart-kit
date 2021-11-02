//
//  ImpactVC.swift
//  BeamKit
//
//  Created by ALEXANDRA SALVATORE on 10/9/19.
//  Copyright © 2019 Beam Impact. All rights reserved.
//

import Foundation
import UIKit

class BKImpactVC: UIViewController {
    weak var context: BKImpactContext?
    weak var flow: BKImpactFlow?
    
    let impactIdentifier = "bk_impact_cell"
    let headerView: UIView = .init(with: .clear)
    
    let separatorLine: UIView = .init(with: .beamGray1)
    let nonprofitLabel: GradientTextView = .init(with: [UIColor.beamGradientLightYellow.cgColor,
                                                        UIColor.beamGradientLightOrange.cgColor],
                                                 text: "Nonprofits You've Supported",
                                                 font: UIFont.beamBold(size: 18))
    private let impactTableView: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
       // table.rowHeight = 340
        table.estimatedRowHeight = 340
        table.separatorInset = .zero
        table.layoutMargins = .zero
        table.separatorStyle = .none
        return table
    }()
    
    
    init(context: BKImpactContext,
         flow: BKImpactFlow) {
        self.context = context
        self.flow = flow
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        view = impactTableView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // headerView.addSubview(nonprofitLabel.usingConstraints())
        //headerView.addSubview(separatorLine.usingConstraints())
        impactTableView.dataSource = self
        impactTableView.delegate = self
        impactTableView.tableHeaderView = headerView
        impactTableView.register(BKImpactCell.self,
                                 forCellReuseIdentifier: impactIdentifier)
        listen()
        //setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
//        headerView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: nonprofitLabel.intrinsicContentSize.height + 20)
             headerView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 15)
        impactTableView.reloadData()

    }
    
    func setupConstraints() {

        let views: Views = ["header": headerView,
                            "line": separatorLine,
                            "label": nonprofitLabel]
        let formats: [String] = ["H:|-20-[label]-20-|",
                                 "H:|[line]|",
                                 "V:|-4-[label]-4-[line(1)]-8-|"]
        let constraints: Constraints =
            NSLayoutConstraint.constraints(withFormats: formats, views: views)
        
        NSLayoutConstraint.activate(constraints)
    }
    
    func listen() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didLoadImpact),
                                               name: ._bkDidUpdateImpact,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(donationsUpdate),
                                               name: ._bkdidCompleteTransaction,
                                               object: nil)

    }
    

}

extension BKImpactVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let context = context else {
            // TODO surface BeamError.invalidConfiguration
            return 0
        }
        return context.numberOfNonprofits
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let context = context,
            let cell = impactTableView.dequeueReusableCell(withIdentifier: impactIdentifier,
                                                             for: indexPath) as? BKImpactCell else {
            return UITableViewCell()
        }
        if let impact = context.nonprofits?[indexPath.row] {
            cell.configure(with: impact)
        }
        return cell
    }
}

extension BKImpactVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
}

extension BKImpactVC {
    @objc
    func didLoadImpact() {
        DispatchQueue.main.async { [weak self] in
            guard let `self` = self else { return }
            self.impactTableView.reloadData()
            //todo update chain name
        }
    }

    @objc
    func donationsUpdate() {
        guard let context = context else {
            // TODO surface BeamError.invalidConfiguration
            return
        }
        context.loadImpact()
    }
}
