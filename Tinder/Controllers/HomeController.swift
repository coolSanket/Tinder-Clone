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

class HomeController: UIViewController {

    let bottomControlStackView = HomeBottomControlStackView()
    let topStackView = HomeTopNavigationStackView()
    let cardDeckView = UIView()

    
    var cardViewModels = [CardViewModel]() // empty cardViewModels
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupFirestoreUserCards()
        bottomControlStackView.refreshButton.addTarget(self, action: #selector(handleRefresh), for: .touchUpInside)
        topStackView.settingsButton.addTarget(self, action: #selector(handleSettings), for: .touchUpInside)
        
        fetchUsersFromFirestore()
    }
    
    
    
    @objc fileprivate func handleRefresh() {
        fetchUsersFromFirestore()
    }
    
    var lastFetchedUser : User?
    
    fileprivate func fetchUsersFromFirestore() {
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Fetching users"
        hud.show(in: self.view)
        
        // implement pagignation
        print("Fetching users from firestore..")
        let query = Firestore.firestore().collection("Users").order(by: "uid").start(after: [lastFetchedUser?.uid ?? ""]).limit(to: 2)
        query.getDocuments { (snapshot, error) in
            hud.dismiss()
            if let error = error {
                print(error.localizedDescription)
                return
            }
            guard let documents = snapshot?.documents else { return }
            for document  in documents {
                let user = User(dictionary: document.data())
                self.cardViewModels.append(user.toCardViewModel())
                self.lastFetchedUser = user
                self.setupCardFromUser(user: user)
            }
            
            // self.setupFirestoreUserCards()
        }
    }
    
    fileprivate func setupCardFromUser(user : User) {
        let cardView = CardView()
        cardView.cardViewModel = user.toCardViewModel()
        cardDeckView.addSubview(cardView)
        cardDeckView.sendSubviewToBack(cardView)
        cardView.fillSuperview()
    }
    
    @objc fileprivate func handleSettings() {
        print("Show registration page..")
        let settingsVC = SettingsController()
        let navController = UINavigationController(rootViewController: settingsVC)
        present(navController, animated: true)
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

