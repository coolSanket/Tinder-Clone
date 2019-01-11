//
//  HomeBottomControlStackView.swift
//  Tinder
//
//  Created by sanket kumar on 11/01/19.
//  Copyright © 2019 sanket kumar. All rights reserved.
//

import UIKit

class HomeBottomControlStackView: UIStackView {

    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        axis = .horizontal
        distribution = .fillEqually
        heightAnchor.constraint(equalToConstant: 100).isActive = true

        
        let subViews = [#imageLiteral(resourceName: "3 1"),#imageLiteral(resourceName: "3 2"),#imageLiteral(resourceName: "3 3"),#imageLiteral(resourceName: "3 4"),#imageLiteral(resourceName: "3 5")].map { (img) -> UIView in
            let button = UIButton(type: .system)
            button.setImage(img.withRenderingMode(.alwaysOriginal), for: .normal)
            return button
        }
        
        subViews.forEach { (v) in
            addArrangedSubview(v)
        }
        
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    

}
