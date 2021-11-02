//
//  TitleImageView.swift
//  BeamKit
//
//  Created by ALEXANDRA SALVATORE on 10/10/19.
//  Copyright © 2019 Beam Impact. All rights reserved.
//

import UIKit

class TitleImageView: UIView {
    
    var title: String = "" {
        didSet {
            titleLabel.text = title
        }
    }
    
    var image: UIImage? = nil {
        didSet {
            mainImageView.image = image
        }
    }
        
    private let mainImageView: UIImageView = {
        let view = UIImageView(frame: .zero)
        view.backgroundColor = .clear
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()
    
    private let tintView: UIView = .init(with: .beamGray3)
    
    private let titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.backgroundColor = .clear
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        label.textColor = .white
        label.font = .beamBold(size: 30)
        return label
    }()
    
    init(title: String? = nil,
         image: UIImage? = nil) {
        super.init(frame: .zero)
        if let title = title {
            titleLabel.text = title
        }
        mainImageView.image = image
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        addSubview(mainImageView.usingConstraints())
        addSubview(tintView.usingConstraints())
        addSubview(titleLabel.usingConstraints())
        clipsToBounds = true
        tintView.alpha = 0.3
        setupConstraints()
    }
    
    func setupConstraints() {
        let views: Views = ["image": mainImageView,
                            "tint": tintView,
                            "title": titleLabel]
        
        let formats: [String] = ["H:|[image]|",
                                 "H:|[tint]|",
                                 "H:|->=40-[title]->=40-|",
                                 "V:|[image]|",
                                 "V:|[title]|",
                                 "V:|[tint]|"]
        var constraints: Constraints = NSLayoutConstraint.constraints(withFormats: formats,
                                                                      views: views)
        constraints += NSLayoutConstraint.center(titleLabel, in: mainImageView)
        NSLayoutConstraint.activate(constraints)
    }
    
    public func setImageWithUrl(_ url:URL, priority: Operation.QueuePriority = .normal) {
        mainImageView.bkSetImageWithUrl(url, placeHolderImage: nil, priority: priority)
    }
    
    public func prepareForReuse() {
        mainImageView.image = nil
        mainImageView.bkcancelImageRequestOperation()
    }
}
