//
//  ViewController.swift
//  Tinder
//
//  Created by sanket kumar on 11/01/19.
//  Copyright © 2019 sanket kumar. All rights reserved.
//

import UIKit
import Firebase

class HomeController: UIViewController {

    let bottomStackView = HomeBottomControlStackView()
    let topStackView = HomeTopNavigationStackView()
    let cardDeckView = UIView()
  
//    let cardViewModels : [CardViewModel] = {
//        let models = [
//            User(name: "Kelly", age: 23, profession: "Music DJ", imageNames: ["kelly1","kelly2","kelly3"]),
//            User(name: "Jane", age: 18, profession: "Student", imageNames: ["jane1","jane2","jane3"]),
//            Advertiser(title: "Instagram", brandName: "Owned by Facebook", posterPhotoName: "instagram"),
//            User(name: "Jane", age: 18, profession: "Student", imageNames: ["jane1","jane2","jane3"])
//
//        ] as [CardViewModelProtocol]
//
//        let viewModels = models.map({return $0.toCardViewModel()})
//        return viewModels
//    }()
    
    var cardViewModels = [CardViewModel]() // empty cardViewModels
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupDummyCards()
        topStackView.settingsButton.addTarget(self, action: #selector(handleSettings), for: .touchUpInside)
        
        fetchUsersFromFirestore()
    }
    
    
    fileprivate func fetchUsersFromFirestore() {
        print("Fetching users from firestore..")
        Firestore.firestore().collection("Users").getDocuments { (snapshot, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            guard let documents = snapshot?.documents else { return }
            for document  in documents {
                let user = User(dictionary: document.data())
                self.cardViewModels.append(user.toCardViewModel())
            
            }
            self.setupDummyCards()
        }
    }
    
    
    @objc fileprivate func handleSettings() {
        print("Show registration page..")
        let registrationVC = RegistrationViewController()
        present(registrationVC, animated: true)
    }
    
    fileprivate func setupDummyCards() {
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
        let overAllStackView = UIStackView(arrangedSubviews:[topStackView,cardDeckView,bottomStackView])
        
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

