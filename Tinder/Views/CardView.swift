//
//  CardView.swift
//  Tinder
//
//  Created by sanket kumar on 11/01/19.
//  Copyright © 2019 sanket kumar. All rights reserved.
//

import UIKit
import SDWebImage

protocol CardViewDelegate {
    func didTapMoreInfo()
}

class CardView: UIView {
    
    var delegate : CardViewDelegate?
    fileprivate let imageView = UIImageView(image: #imageLiteral(resourceName: "lady5c").withRenderingMode(.alwaysOriginal))
    fileprivate let informationLabel = UILabel()
    fileprivate let infoBackgroundview = UIView()
    fileprivate let gradientLayer = CAGradientLayer()
    var imageIndex = 0
    fileprivate let barDeselectedColor = UIColor(white: 0, alpha: 0.1)
    
    var cardViewModel : CardViewModel! {
        didSet {
            let imageName = cardViewModel.imageNames.first ?? ""
            // load image from url
            if let url = URL(string: imageName) {
                imageView.sd_setImage(with: url)
            }
            
            informationLabel.attributedText = cardViewModel.attributedString
            informationLabel.textAlignment = cardViewModel.textAlignment
            
            let barViewCount = cardViewModel.imageNames.count
            
            (0..<barViewCount).forEach { (_) in
                let barView = UIView()
                barView.backgroundColor = barDeselectedColor
                barView.translatesAutoresizingMaskIntoConstraints = false
                barStackView.addArrangedSubview(barView)
            }
            // access the first barView
            barStackView.arrangedSubviews.first?.backgroundColor = .white
            
        }
    }
    
    fileprivate let threshold : CGFloat = 100

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupLayout()
    
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        addGestureRecognizer(panGestureRecognizer)
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
        
    }
    
    fileprivate let moreInfoButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "info_icon")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleMoreInfo), for: .touchUpInside)
        return button
    }()
    
    @objc fileprivate func handleMoreInfo() {
        print("More info")
        delegate?.didTapMoreInfo()
    }
    
    fileprivate func setupLayout() {
        layer.cornerRadius = 10
        clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        addSubview(imageView)
        imageView.fillSuperview()
        
        setupBarsStackView()
        
        // add a gradient layer
        setupGradientLayer()
        
        addSubview(informationLabel)
        informationLabel.translatesAutoresizingMaskIntoConstraints = false
        
        informationLabel.anchor(top: nil, leading: self.leadingAnchor, bottom: self.bottomAnchor, trailing: self.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 16, bottom: 16, right: 16))
        
        
        informationLabel.textColor = .white
        informationLabel.numberOfLines = 0
        
        addSubview(moreInfoButton)
        moreInfoButton.anchor(top: nil, leading: nil, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 0, bottom: 8, right: 8), size: .init(width: 44, height: 44))
    }
    
    fileprivate let barStackView = UIStackView()
    
    fileprivate func setupBarsStackView() {
        addSubview(barStackView)
        barStackView.anchor(top: self.topAnchor, leading: self.leadingAnchor, bottom: nil, trailing: self.trailingAnchor,padding: .init(top: 8, left: 8, bottom: 0, right: 8),size: CGSize(width: 0, height: 4))
        
        barStackView.distribution = .fillEqually
        barStackView.spacing = 4
        barStackView.axis = .horizontal
        
        
    }
    
    fileprivate func setupGradientLayer() {
        gradientLayer.colors = [UIColor.clear.cgColor,UIColor.black.cgColor]
        gradientLayer.locations = [0.5,1.1]
        // here can't use self.frame beacuse it is zero
        // gradientLayer.frame = self.frame
        layer.addSublayer(gradientLayer)
    }
    
    
    override func layoutSubviews() {
        // self.frame is not zere
        gradientLayer.frame = self.frame
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    @objc fileprivate func handleTap(gesture : UITapGestureRecognizer) {
        print("Handling tap...")
        let tapLocation = gesture.location(in: nil)
        let shouldAdvanceToNextPhoto = tapLocation.x > frame.width / 2 ? true : false
        if shouldAdvanceToNextPhoto {
             imageIndex = min(imageIndex + 1, cardViewModel.imageNames.count - 1)
        }
        else {
             imageIndex = max(0, imageIndex - 1)
        }
        let imageUrl = cardViewModel.imageNames[imageIndex]
        if let url = URL(string: imageUrl) {
            imageView.sd_setImage(with: url)
        }
        barStackView.arrangedSubviews.forEach { (v) in
            v.backgroundColor = barDeselectedColor
        }
        barStackView.arrangedSubviews[imageIndex].backgroundColor = .white
    }
    
    @objc fileprivate func handlePan(gesture : UIPanGestureRecognizer) {
        
        switch gesture.state {
        case .began :
            superview?.subviews.forEach({ (subview) in
                subview.layer.removeAllAnimations()
            })
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

