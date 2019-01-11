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
    let blueView = UIView()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        blueView.backgroundColor = .blue
        setupLayout()
        
    }
    
    //MARK:- setup layout
    
    fileprivate func setupLayout() {
        let overAllStackView = UIStackView(arrangedSubviews:[topStackView,blueView,bottomStackView])
        
        overAllStackView.axis = .vertical
        self.view.addSubview(overAllStackView)
        
        // Fill the entire super view
        overAllStackView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor)
    }
    
    


}

