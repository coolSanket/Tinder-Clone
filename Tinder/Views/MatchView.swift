//
//  MatchView.swift
//  Tinder
//
//  Created by sanket kumar on 20/02/19.
//  Copyright © 2019 sanket kumar. All rights reserved.
//

import UIKit


class MatchView: UIView {
    
    
    let currentUserImageView : UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "lady4c"))
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    let likedUserImageView : UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "kelly2"))
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupBlurView()
        setupLayout()
    }
    
    
    fileprivate func setupLayout() {
        addSubview(currentUserImageView)
        addSubview(likedUserImageView)
        
        currentUserImageView.anchor(top: nil, leading: nil, bottom: nil, trailing: centerXAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 16), size: .init(width: 140, height: 140))
        currentUserImageView.layer.cornerRadius = 140/2
        currentUserImageView.layer.borderWidth = 2
        currentUserImageView.layer.borderColor = UIColor.white.cgColor
        currentUserImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        
        likedUserImageView.anchor(top: nil, leading: centerXAnchor, bottom: nil, trailing: nil, padding: .init(top: 0, left: 16, bottom: 0, right: 0), size: .init(width: 140, height: 140))
        likedUserImageView.layer.cornerRadius = 140/2
        likedUserImageView.layer.borderWidth = 2
        likedUserImageView.layer.borderColor = UIColor.white.cgColor
        likedUserImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    let blurEffect = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    
    fileprivate func setupBlurView() {
        blurEffect.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
        
        addSubview(blurEffect)
        blurEffect.fillSuperview()
        blurEffect.alpha = 0
        
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.blurEffect.alpha = 1
        }) { (_) in
            
        }
    }
    
    @objc fileprivate func handleDismiss() {
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.alpha = 0
        }) { (_) in
            self.removeFromSuperview()
        }
    
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
