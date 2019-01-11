//
//  HomeTopNavigationStackView.swift
//  Tinder
//
//  Created by sanket kumar on 11/01/19.
//  Copyright © 2019 sanket kumar. All rights reserved.
//

import UIKit

class HomeTopNavigationStackView: UIStackView {
    
    
    let settingsButton = UIButton(type: .system)
    let messageButton = UIButton(type: .system)
    let fireImageView = UIImageView(image: #imageLiteral(resourceName: "3 7").withRenderingMode(.alwaysOriginal))

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        fireImageView.contentMode = .scaleAspectFit
        settingsButton.setImage(#imageLiteral(resourceName: "3 6").withRenderingMode(.alwaysOriginal), for: .normal)
        messageButton.setImage(#imageLiteral(resourceName: "3 8").withRenderingMode(.alwaysOriginal), for: .normal)
        
        [settingsButton,UIView(),fireImageView,UIView(),messageButton].forEach { (v) in
            addArrangedSubview(v)
        }
        
        axis = .horizontal
        distribution = .equalCentering
        heightAnchor.constraint(equalToConstant: 60).isActive = true
        isLayoutMarginsRelativeArrangement = true
        layoutMargins = .init(top: 0, left: 16, bottom: 0, right: 16)

    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    

}
