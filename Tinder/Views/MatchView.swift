//
//  MatchView.swift
//  Tinder
//
//  Created by sanket kumar on 20/02/19.
//  Copyright © 2019 sanket kumar. All rights reserved.
//

import UIKit


class MatchView: UIView {
    
    let itsMatchImageView : UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "its_match"))
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    let descriptionLabel : UILabel = {
        let label = UILabel()
        label.text = "You and X have liked \n each other"
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 18)
        label.numberOfLines = 2
        return label
    }()
    
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
    
    let sendMessageButton : SendMessageButton = {
        let button = SendMessageButton(type: .system)
        button.setTitle("Send Message", for: .normal)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    let keepSwippingButton : KeepSwippingButton = {
        let button = KeepSwippingButton(type: .system)
        button.setTitle("Keep Swipping", for: .normal)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupBlurView()
        setupLayout()
        
        setupAnimation()
    }
    
    fileprivate func setupAnimation() {
        let angle : CGFloat = 30 * CGFloat.pi / 180
        self.currentUserImageView.transform = CGAffineTransform(rotationAngle: -angle).concatenating(CGAffineTransform(translationX: 200, y: 0))
        
        self.likedUserImageView.transform = CGAffineTransform(rotationAngle: angle).concatenating(CGAffineTransform(translationX: -200, y: 0))
        
        self.sendMessageButton.transform = CGAffineTransform(translationX: -500, y: 0)
        self.keepSwippingButton.transform = CGAffineTransform(translationX: 500, y: 0)
        
        UIView.animateKeyframes(withDuration: 0.8, delay: 0, options: .calculationModeCubic, animations: {
            
            // animation 1
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.3, animations: {
                self.currentUserImageView.transform = CGAffineTransform(rotationAngle: -angle)
                self.likedUserImageView.transform = CGAffineTransform(rotationAngle: angle)
            })
            
            // animation 2
            UIView.addKeyframe(withRelativeStartTime: 0.4, relativeDuration: 0.3, animations: {
                self.currentUserImageView.transform = .identity
                self.likedUserImageView.transform = .identity
            })
            
        }) { (_) in
            
        }
        UIView.animate(withDuration: 0.4, delay: 0.5, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.3, options: .curveEaseOut, animations: {
            self.sendMessageButton.transform = .identity
            self.keepSwippingButton.transform = .identity
        })
    }
    
    
    fileprivate func setupLayout() {
        addSubview(currentUserImageView)
        addSubview(likedUserImageView)
        addSubview(descriptionLabel)
        addSubview(itsMatchImageView)
        addSubview(sendMessageButton)
        addSubview(keepSwippingButton)
        
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
        
        descriptionLabel.anchor(top: nil, leading: nil, bottom: likedUserImageView.topAnchor, trailing: nil, padding: .init(top: 0, left: 0, bottom: 32, right: 0), size: .init(width: 0, height: 60))
        descriptionLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        itsMatchImageView.anchor(top: nil, leading: nil, bottom: descriptionLabel.topAnchor, trailing: nil, padding: .init(top: 0, left: 0, bottom: 32, right: 0), size: .init(width: 0, height: 54))
        itsMatchImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        sendMessageButton.anchor(top: currentUserImageView.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 32, left: 48, bottom: 0, right: 48),size: .init(width: 0, height: 54))
        
        keepSwippingButton.anchor(top: sendMessageButton.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 16, left: 48, bottom: 0, right: 48),size: .init(width: 0, height: 54))
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
