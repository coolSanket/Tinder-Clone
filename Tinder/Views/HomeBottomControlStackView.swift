//
//  HomeBottomControlStackView.swift
//  Tinder
//
//  Created by sanket kumar on 11/01/19.
//  Copyright © 2019 sanket kumar. All rights reserved.
//

import UIKit


class HomeBottomControlStackView: UIStackView {
    
    let refreshButton = createButton(image: #imageLiteral(resourceName: "3 1"))
    let dislikeButton = createButton(image: #imageLiteral(resourceName: "3 2"))
    let superlikeButton = createButton(image: #imageLiteral(resourceName: "3 3"))
    let likeButton = createButton(image: #imageLiteral(resourceName: "3 4"))
    let specialButton = createButton(image: #imageLiteral(resourceName: "3 5"))
    
    
    static func createButton(image : UIImage) -> UIButton {
        let button = UIButton(type: .system)
        button.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        axis = .horizontal
        distribution = .fillEqually
        heightAnchor.constraint(equalToConstant: 100).isActive = true

        [refreshButton,dislikeButton,superlikeButton,likeButton,specialButton].forEach { (button) in
            self.addArrangedSubview(button)
        }
        
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
