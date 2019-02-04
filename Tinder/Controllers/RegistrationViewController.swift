//
//  RegistrationViewController.swift
//  Tinder
//
//  Created by sanket kumar on 13/01/19.
//  Copyright © 2019 sanket kumar. All rights reserved.
//

import UIKit
import Firebase
import JGProgressHUD


extension RegistrationViewController : UIImagePickerControllerDelegate , UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.originalImage] as? UIImage
        registrationModel.bindableImage.value = image
        registrationModel.checkFormValidity()
        dismiss(animated: true)
    }
}

class RegistrationViewController: UIViewController {

    // UI Compenents
    let selectPhotoBtn : UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Select Photo", for: .normal)
        btn.backgroundColor = .white
        btn.setTitleColor(.black, for: .normal)
        btn.layer.cornerRadius = 16
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 32, weight: .heavy)
        btn.heightAnchor.constraint(equalToConstant: 300).isActive = true
        btn.addTarget(self, action: #selector(handleSelectPhoto), for: .touchUpInside)
//        btn.imageView?.contentMode = .scaleAspectFill
        btn.clipsToBounds = true
        return btn
    }()
    
    @objc fileprivate func handleSelectPhoto() {
        print("Select photo...")
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        present(imagePickerController, animated: true)
    }

    let nameTextField : CustomTextField = {
        let textField = CustomTextField(padding: 16, height: 44)
        textField.placeholder = "Name"
        textField.backgroundColor = .white
        textField.addTarget(self, action: #selector(handleTextChanged), for: .editingChanged)
        return textField
    }()
    
    let emailTextField : CustomTextField = {
        let textField = CustomTextField(padding: 16, height: 44)
        textField.placeholder = "Email"
        textField.backgroundColor = .white
        textField.keyboardType = .emailAddress
        textField.addTarget(self, action: #selector(handleTextChanged), for: .editingChanged)
        return textField
    }()
    
    let passwordTextField : CustomTextField = {
        let textField = CustomTextField(padding: 16, height: 44)
        textField.placeholder = "Password"
        textField.backgroundColor = .white
        textField.isSecureTextEntry = true
        textField.addTarget(self, action: #selector(handleTextChanged), for: .editingChanged)
        return textField
    }()
    
    @objc fileprivate func handleTextChanged(textField : UITextField) {
        if textField == nameTextField {
            registrationModel.name = textField.text
        }
        else if textField == emailTextField {
            registrationModel.email = textField.text
        }
        else {
            registrationModel.password = textField.text
        }
    }
    
    let registerButton : UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Register", for: .normal)
        btn.backgroundColor = .lightGray
        btn.isEnabled = false
        btn.setTitleColor(UIColor.black, for: .disabled)
        btn.setTitleColor(.white, for: .normal)
        btn.layer.cornerRadius = 22
        btn.heightAnchor.constraint(equalToConstant: 44).isActive = true
        btn.addTarget(self, action: #selector(handleRegister), for: .touchUpInside)
        return btn
    }()
    
    let registeringHUD = JGProgressHUD(style: .dark)
    
    @objc fileprivate func handleRegister() {
        self.handleTapDismiss()
        print("Register user...")
        registrationModel.performRegistration { [weak self] (error) in
            self?.clearTextFields()
            if let error = error {
                self?.showJGHudWithError(error: error)
                return
            }
        }
    }
    
    fileprivate func clearTextFields() {
        self.nameTextField.text = ""
        self.emailTextField.text = ""
        self.passwordTextField.text = ""
    }
    
    fileprivate func showJGHudWithError(error : Error) {
        registeringHUD.dismiss()
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Failed to register user."
        hud.detailTextLabel.text = "\(error.localizedDescription)"
        hud.show(in: self.view)
        hud.dismiss(afterDelay: 4, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupGradientLayer()
        setupLayout()
        setupNotificationObservers()
        setupTapGesture()
        setupRegistrationViewModelObserver()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // NotificationCenter.default.removeObserver(self)
    }
    
    
    let registrationModel = RegistrationViewModel()
    fileprivate func setupRegistrationViewModelObserver() {
        
        registrationModel.bindableIsFormValid.bind { [unowned self] (isFormValid) in
            guard let isFormValid = isFormValid else { return }
            self.registerButton.isEnabled = isFormValid
            self.registerButton.backgroundColor = isFormValid ? #colorLiteral(red: 0.4392156899, green: 0.01176470611, blue: 0.1921568662, alpha: 1) : .lightGray
        }
        registrationModel.bindableImage.bind { [unowned self] (image) in
            self.selectPhotoBtn.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        
        registrationModel.bindableIsRegistering.bind { [unowned self] (isRegistering) in
            guard let isRegistering = isRegistering else { return }
            if isRegistering {
                self.registeringHUD.textLabel.text = "Registering..."
                self.registeringHUD.show(in: self.view)
            }
            else {
                self.registeringHUD.dismiss()
            }
        }
        
    }
    
    fileprivate func setupTapGesture() {
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapDismiss)))
    }
    
    @objc fileprivate func handleTapDismiss() {
        self.view.endEditing(true)
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.transform = .identity
        })
    }
    
    fileprivate func setupNotificationObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKayboardHide), name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    @objc fileprivate func handleKayboardHide() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.transform = .identity
        })
    }
    
    @objc fileprivate func handleKeyboardShow(notification : Notification) {
        guard let value = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }
        let keyboardFrame = value.cgRectValue
        let bottomSpace = view.frame.height - stackView.frame.origin.y - stackView.frame.height

        print("Keyboard height : ",keyboardFrame.height)
        print("Bottom space",bottomSpace)
        
        let diff = keyboardFrame.height - bottomSpace
        view.transform = CGAffineTransform(translationX: 0, y: -diff - 8)
        
    }
    
    lazy var stackView = UIStackView(arrangedSubviews: [
        selectPhotoBtn,
        nameTextField,
        emailTextField,
        passwordTextField,
        registerButton
        ])
    
    let goToLoginPageButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Go to login page", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .heavy)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(handleGoToLoginPage), for: .touchUpInside)
        return button
    }()
    
    @objc fileprivate func handleGoToLoginPage() {
        let loginVC = LoginController()
        navigationController?.pushViewController(loginVC, animated: true)
    }
    
    fileprivate func setupLayout() {
        // hide navigation bar
        navigationController?.isNavigationBarHidden = true
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stackView)
        stackView.anchor(top: nil, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 0, left: 32, bottom: 0, right: 32))
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -60).isActive = true
        
        view.addSubview(goToLoginPageButton)
        goToLoginPageButton.anchor(top: nil, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor)
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

