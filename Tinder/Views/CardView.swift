//
//  CardView.swift
//  Tinder
//
//  Created by sanket kumar on 11/01/19.
//  Copyright © 2019 sanket kumar. All rights reserved.
//

import UIKit

class CardView: UIView {
    
    fileprivate let imageView = UIImageView(image: #imageLiteral(resourceName: "lady5c").withRenderingMode(.alwaysOriginal))
    fileprivate let informationLabel = UILabel()
    fileprivate let infoBackgroundview = UIView()
    
    var cardViewModel : CardViewModel! {
        didSet {
            imageView.image = UIImage(named: cardViewModel.imageName)
            informationLabel.attributedText = cardViewModel.attributedString
            informationLabel.textAlignment = cardViewModel.textAlignment
        }
    }
    
    fileprivate let threshold : CGFloat = 100

    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 10
        clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        addSubview(imageView)
        imageView.fillSuperview()
        
        addSubview(infoBackgroundview)
        infoBackgroundview.backgroundColor = UIColor.black.withAlphaComponent(0.25)
        infoBackgroundview.translatesAutoresizingMaskIntoConstraints = false
        infoBackgroundview.anchor(top: nil, leading: self.leadingAnchor, bottom: self.bottomAnchor, trailing: self.trailingAnchor)
        
        infoBackgroundview.addSubview(informationLabel)
        informationLabel.translatesAutoresizingMaskIntoConstraints = false
        
        informationLabel.anchor(top: infoBackgroundview.topAnchor, leading: self.leadingAnchor, bottom: self.bottomAnchor, trailing: self.trailingAnchor, padding: UIEdgeInsets(top: 8, left: 16, bottom: 16, right: 16))
        
        informationLabel.text = "TEST TEST ,TEST"
        informationLabel.textColor = .white
        informationLabel.numberOfLines = 0
        
        informationLabel.font = UIFont.systemFont(ofSize: 32, weight: .heavy)
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        addGestureRecognizer(panGestureRecognizer)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @objc fileprivate func handlePan(gesture : UIPanGestureRecognizer) {
        
        switch gesture.state {
        case .changed:
            handleChanged(gesture)
        case.ended :
            handleEnded(gesture)
        default:
            ()
        }
    }
    
    fileprivate func handleChanged(_ gesture: UIPanGestureRecognizer) {
        
        let translation = gesture.translation(in: nil)
        let degree : CGFloat = translation.x / 15
        let angle = degree * .pi / 180
        // rotation
        let rotationalTransformation = CGAffineTransform(rotationAngle: angle)
        self.transform = rotationalTransformation.translatedBy(x: translation.x, y: translation.y)
        
    }
    
    
    fileprivate func handleEnded(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: nil)
        let shouldDismissCard = translation.x > threshold || translation.x < -threshold
        
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.7, options: .curveEaseOut, animations: {
            if shouldDismissCard {
                let transX : CGFloat = translation.x > 0 ? 1000 : -1000
                self.frame = CGRect(x: transX, y: 0, width: self.frame.width, height: self.frame.height)
            }
            else {
                self.transform = .identity
            }
            
        }) { (_) in
            self.transform = .identity
            if shouldDismissCard {
                self.removeFromSuperview()
            }
        }
    }
    
}

