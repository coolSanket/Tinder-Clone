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
        
        guard let minSeekingAge = user?.minSeekingAge, let maxSeekingAge = user?.maxSeekingAge else { return  }
        
        // implement pagignation
        print("Fetching users from firestore..")
        let query = Firestore.firestore().collection("Users").whereField("age", isGreaterThanOrEqualTo: minSeekingAge).whereField("age", isLessThanOrEqualTo: maxSeekingAge)
        query.getDocuments { (snapshot, error) in
            hud.dismiss()
            if let error = error {
                print(error.localizedDescription)
                return
            }
            guard let documents = snapshot?.documents else { return }
            for document  in documents {
                let user = User(dictionary: document.data())
                if user.uid != Auth.auth().currentUser?.uid {
                    self.setupCardFromUser(user: user)
                }
            }
        }
    }
    
    fileprivate func setupCardFromUser(user : User) {
        let cardView = CardView()
        cardView.delegate = self
        cardView.cardViewModel = user.toCardViewModel()
        cardDeckView.addSubview(cardView)
        cardDeckView.sendSubviewToBack(cardView)
        cardView.fillSuperview()
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

