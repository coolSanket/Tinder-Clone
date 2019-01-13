//
//  RegistrationViewController.swift
//  Tinder
//
//  Created by sanket kumar on 13/01/19.
//  Copyright © 2019 sanket kumar. All rights reserved.
//

import UIKit

class RegistrationViewController: UIViewController {

    // UI Compenents
    let selectPhotoBtn : UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Select Photo", for: .normal)
        btn.backgroundColor = .white
        btn.setTitleColor(.black, for: .normal)
        btn.layer.cornerRadius = 16
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 32, weight: .heavy)
        btn.heightAnchor.constraint(equalToConstant: 250).isActive = true
        return btn
    }()
    

    let nameTextField : CustomTextField = {
        let textField = CustomTextField(padding: 16)
        textField.placeholder = "Name"
        textField.backgroundColor = .white
        return textField
    }()
    
    let emailTextField : CustomTextField = {
        let textField = CustomTextField(padding: 16)
        textField.placeholder = "Email"
        textField.backgroundColor = .white
        textField.keyboardType = .emailAddress
        return textField
    }()
    
    let passwordTextField : CustomTextField = {
        let textField = CustomTextField(padding: 16)
        textField.placeholder = "Password"
        textField.backgroundColor = .white
        textField.isSecureTextEntry = true
        return textField
    }()
    
    let registerButton : UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Register", for: .normal)
        btn.backgroundColor = #colorLiteral(red: 0.4392156899, green: 0.01176470611, blue: 0.1921568662, alpha: 1)
        btn.setTitleColor(.white, for: .normal)
        btn.layer.cornerRadius = 22
        btn.heightAnchor.constraint(equalToConstant: 44).isActive = true
        return btn
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupGradientLayer()
        // view.backgroundColor = .red
        
        let stackView = UIStackView(arrangedSubviews: [
            selectPhotoBtn,
            nameTextField,
            emailTextField,
            passwordTextField,
            registerButton
            ])
        
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stackView)
        stackView.anchor(top: nil, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 0, left: 32, bottom: 0, right: 32))
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -60).isActive = true
        
    }
    
    fileprivate func setupGradientLayer() {
        let gradientLayer = CAGradientLayer()
        let topColor = #colorLiteral(red: 0.9921568627, green: 0.3568627451, blue: 0.337254902, alpha: 1)
        let bottomColor = #colorLiteral(red: 0.8980392157, green: 0, blue: 0.4470588235, alpha: 1)
        gradientLayer.colors = [topColor.cgColor,bottomColor.cgColor]
        gradientLayer.locations = [0,1]
        view.layer.addSublayer(gradientLayer)
        gradientLayer.frame = view.bounds
    }
    
    
}
