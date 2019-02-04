//
//  UserDetailController.swift
//  Tinder
//
//  Created by sanket kumar on 31/01/19.
//  Copyright © 2019 sanket kumar. All rights reserved.
//

import UIKit
import SDWebImage

class UserDetailController: UIViewController , UIScrollViewDelegate {
    
    let swipingPhotoController = SwipingPhotosController()
    
    var cardViewModel : CardViewModel! {
        didSet {
            infoLabel.attributedText = cardViewModel.attributedString
            swipingPhotoController.cardViewModel = cardViewModel
        }
    }
    lazy var scrollView : UIScrollView = {
        let sv = UIScrollView()
        sv.alwaysBounceVertical = true
        sv.contentInsetAdjustmentBehavior = .never
        sv.delegate = self
        return sv
    }()
    
    let dismissButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "dismiss_down_arrow").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleTapDismiss), for: .touchUpInside)
        return button
    }()
    
    let infoLabel : UILabel = {
        let label = UILabel()
        label.text = "Sanket Kumar 23 \nAssistant System Engineer \nSome amazig bio"
        label.numberOfLines = 0
        return label
    }()
    
    lazy var superLikeButton = self.createButtons(image: #imageLiteral(resourceName: "3 3"), selector: #selector(handleSuperLike))
    lazy var dislikeButton = self.createButtons(image: #imageLiteral(resourceName: "3 2"), selector: #selector(handleDislike))
    lazy var likeButton = self.createButtons(image: #imageLiteral(resourceName: "3 4"), selector: #selector(handleLike))

    @objc fileprivate func handleLike() {
        print("Liked...")
    }
    
    @objc fileprivate func handleDislike() {
        print("Disliked...")
    }
    
    @objc fileprivate func handleSuperLike() {
        print("Superlike...")
    }
    
    fileprivate func createButtons(image : UIImage,selector : Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: selector, for: .touchUpInside)
        return button
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        setupLayout()
        setupvisualBlurEffect()
        setupBottomControls()
        
    }
    
    fileprivate let swipingExtraHeight : CGFloat = 80
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        let swipingView = swipingPhotoController.view!
        swipingView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.width + swipingExtraHeight)
    }
    
    fileprivate func setupvisualBlurEffect() {
        let blurEffect = UIBlurEffect(style: .light)
        let visualEffectView = UIVisualEffectView(effect: blurEffect)
        view.addSubview(visualEffectView)
        visualEffectView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.topAnchor, trailing: view.trailingAnchor)
    }
    
    fileprivate func setupBottomControls() {
        let stackView = UIStackView(arrangedSubviews: [
            dislikeButton,
            superLikeButton,
            likeButton
            ])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        
        scrollView.addSubview(stackView)
        stackView.anchor(top: nil, leading: nil, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: nil, padding: .init(top: 0, left: 0, bottom: 16, right: 0))
        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    fileprivate func setupLayout() {
        view.addSubview(scrollView)
        scrollView.fillSuperview()
        
        let swipingView = swipingPhotoController.view!
        scrollView.addSubview(swipingView)
        scrollView.addSubview(infoLabel)
        infoLabel.anchor(top: swipingView.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor,padding: .init(top: 16, left: 16, bottom: 0, right: 16))
        
        scrollView.addSubview(dismissButton)
        dismissButton.anchor(top: nil, leading: nil, bottom: swipingView.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 0, bottom: -22, right: 16),size: CGSize(width: 44, height: 44))
        
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let changeY = -scrollView.contentOffset.y
        let width = max(self.view.frame.width + changeY * 2, self.view.frame.width)
        let swipingView = swipingPhotoController.view!
        swipingView.frame = CGRect(x: min(0, -changeY), y: min(0, -changeY), width: width, height: width + swipingExtraHeight)
    }
    
   
    
    

    @objc fileprivate func handleTapDismiss() {
        self.dismiss(animated: true, completion: nil)
    }
    
}
