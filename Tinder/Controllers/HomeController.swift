//
//  ViewController.swift
//  Tinder
//
//  Created by sanket kumar on 11/01/19.
//  Copyright © 2019 sanket kumar. All rights reserved.
//

import UIKit
import Firebase
import JGProgressHUD

class HomeController: UIViewController, SettingsControllerDelegate , LoginControllerDelegate, CardViewDelegate {
    
    
    
    let bottomControlStackView = HomeBottomControlStackView()
    let topStackView = HomeTopNavigationStackView()
    let cardDeckView = UIView()

    
    var cardViewModels = [CardViewModel]() // empty cardViewModels
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        
        bottomControlStackView.refreshButton.addTarget(self, action: #selector(handleRefresh), for: .touchUpInside)
        topStackView.settingsButton.addTarget(self, action: #selector(handleSettings), for: .touchUpInside)
        bottomControlStackView.likeButton.addTarget(self, action: #selector(handleLike), for: .touchUpInside)
        bottomControlStackView.dislikeButton.addTarget(self, action: #selector(handleDislike), for: .touchUpInside)
        
        
        fetchCurrentUser()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        print("View did appear")
        if Auth.auth().currentUser == nil {
            let loginController = LoginController()
            loginController.delegate = self
            let navController = UINavigationController(rootViewController: loginController)
            present(navController, animated: true, completion: nil)
        }
    }
    
    func didFinishLoggingIn() {
        fetchCurrentUser()
    }
    
    fileprivate var user : User?
    fileprivate func fetchCurrentUser() {
        
        let shared = FirebaseRequest.shared
        shared.fetchCurrentUser(completion: {[weak self] (user) in
            self?.user = user
            self?.setupFirestoreUserCards()
            self?.fetchUsersFromFirestore()
        })
    }
    
    
    @objc fileprivate func handleRefresh() {
        fetchUsersFromFirestore()
    }
    
    fileprivate func removePrevoiusCards() {
        for view in cardDeckView.subviews {
            view.removeFromSuperview()
        }
    }
    
    var lastFetchedUser : User?
    fileprivate func fetchUsersFromFirestore() {
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Fetching users"
        hud.show(in: self.view)

        let minSeekingAge = user?.minSeekingAge ?? 18
        let maxSeekingAge = user?.maxSeekingAge ?? 50
        
        // implement pagignation
        print("Fetching users from firestore..")
        let query = Firestore.firestore().collection("Users").whereField("age", isGreaterThanOrEqualTo: minSeekingAge).whereField("age", isLessThanOrEqualTo: maxSeekingAge)
        topCardView = nil
        query.getDocuments { (snapshot, error) in
            hud.dismiss()
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            // use linked list for next card
            var prevCardView : CardView?
            guard let documents = snapshot?.documents else { return }
            for document  in documents {
                let user = User(dictionary: document.data())
                if user.uid != Auth.auth().currentUser?.uid {
                    let cardView = self.setupCardFromUser(user: user)
                    prevCardView?.nextCardView = cardView
                    prevCardView = cardView
                    if self.topCardView == nil {
                        self.topCardView = cardView
                    }
                }
            }
        }
    }
    
    var topCardView : CardView?
    @objc fileprivate func handleLike() {
        print("Remove card from stack")
        performSwipeAnimation(toValue: 700, angle: 15)
    }
    
    @objc fileprivate func handleDislike() {
        performSwipeAnimation(toValue: -700, angle: -15)
    }
    
    fileprivate func performSwipeAnimation(toValue : CGFloat,angle : CGFloat) {
        
        let duration = 0.4
        let translatonAnimation = CABasicAnimation(keyPath: "position.x")
        translatonAnimation.toValue = toValue
        translatonAnimation.duration = duration
        translatonAnimation.fillMode = .forwards
        translatonAnimation.isRemovedOnCompletion = false
        translatonAnimation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.toValue = angle * CGFloat.pi / 180
        rotationAnimation.duration = duration
        
        let cardView = topCardView
        topCardView = cardView?.nextCardView
        CATransaction.setCompletionBlock {
            cardView?.removeFromSuperview()
        }
        cardView?.layer.add(translatonAnimation, forKey: "translation")
        cardView?.layer.add(rotationAnimation, forKey: "rotation")
        
        CATransaction.commit()
        
    }
    
    func didRemoveCardView(cardView: CardView) {
        topCardView = topCardView?.nextCardView
    }
    
    
    fileprivate func setupCardFromUser(user : User) -> CardView {
        let cardView = CardView()
        cardView.delegate = self
        cardView.cardViewModel = user.toCardViewModel()
        cardDeckView.addSubview(cardView)
        cardDeckView.sendSubviewToBack(cardView)
        cardView.fillSuperview()
        return cardView
    }
    
    
    
    
    func didTapMoreInfo(cardViewModel: CardViewModel) {
        let userDetailVC = UserDetailController()
        userDetailVC.cardViewModel = cardViewModel
        present(userDetailVC, animated: true)
    }
    
    @objc fileprivate func handleSettings() {
        print("Show registration page..")
        let settingsVC = SettingsController()
        settingsVC.deletate = self
        let navController = UINavigationController(rootViewController: settingsVC)
        present(navController, animated: true)
    }
    
    func didSaveSetting() {
        // fetch user
        fetchCurrentUser()
    }
    
    fileprivate func setupFirestoreUserCards() {
        print("Setting up dummy cards..")
        
        cardViewModels.forEach { (cardViewModel) in
            let cardView = CardView()
            cardView.cardViewModel = cardViewModel
            cardDeckView.addSubview(cardView)
            cardView.fillSuperview()
        }
    }
    
    //MARK:- setup layout
    
    fileprivate func setupLayout() {
        view.backgroundColor = .white
        let overAllStackView = UIStackView(arrangedSubviews:[topStackView,cardDeckView,bottomControlStackView])
        
        overAllStackView.axis = .vertical
        self.view.addSubview(overAllStackView)
        
        // Fill the entire super view
        overAllStackView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor)
        overAllStackView.isLayoutMarginsRelativeArrangement = true
        overAllStackView.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        // all view have z-axiz  property
        overAllStackView.bringSubviewToFront(cardDeckView)
    }
    
    
    
    


}

