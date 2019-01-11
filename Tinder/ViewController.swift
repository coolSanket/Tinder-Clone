//
//  ViewController.swift
//  Tinder
//
//  Created by sanket kumar on 11/01/19.
//  Copyright © 2019 sanket kumar. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let bottomStackView = HomeBottomControlStackView()
    let topStackView = HomeTopNavigationStackView()
    let cardDeckView = UIView()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        setupDummyCards()
        
    }
    
    fileprivate func setupDummyCards() {
        print("Setting up dummy cards..")
        let cardView = CardView()
        cardDeckView.addSubview(cardView)
        cardView.fillSuperview()
    }
    
    //MARK:- setup layout
    
    fileprivate func setupLayout() {
        
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

