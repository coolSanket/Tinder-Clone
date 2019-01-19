//
//  SettingsController.swift
//  Tinder
//
//  Created by sanket kumar on 19/01/19.
//  Copyright © 2019 sanket kumar. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage
import JGProgressHUD

class CustomImagePickerController: UIImagePickerController {
    var imageButton : UIButton?
}


class SettingsController: UITableViewController, UIImagePickerControllerDelegate , UINavigationControllerDelegate {

    
    lazy var imageBtn1 = createButton(selector: #selector(handleSelectPhoto))
    lazy var imageBtn2 = createButton(selector: #selector(handleSelectPhoto))
    lazy var imageBtn3 = createButton(selector: #selector(handleSelectPhoto))
    
    @objc fileprivate func handleSelectPhoto(button : UIButton) {
        print("Selecting photo for button : ",button)
        let imagePicker = CustomImagePickerController()
        imagePicker.delegate = self
        imagePicker.imageButton = button
        present(imagePicker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let selectedImage = info[.originalImage] as? UIImage
        let imageButton = (picker as? CustomImagePickerController)?.imageButton
        imageButton?.setImage(selectedImage?.withRenderingMode(.alwaysOriginal), for: .normal)
        dismiss(animated: true)
        
    }

    func createButton(selector : Selector) -> UIButton {
        let btn = UIButton(type: .system)
        btn.setTitle("Select Photo", for: .normal)
        btn.layer.cornerRadius = 8
        btn.addTarget(self, action: selector, for: .touchUpInside)
        btn.imageView?.contentMode = .scaleAspectFill
        btn.clipsToBounds = true
        btn.backgroundColor = .white
        return btn
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationItems()
        // tableView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        tableView.backgroundColor = UIColor(red: 239/255, green: 239/255, blue: 244/255, alpha: 1)
        tableView.tableFooterView = UIView()
        tableView.keyboardDismissMode = .interactive
        
        fetchCurrentUser()
        
    }
    
    var user : User?
    fileprivate func fetchCurrentUser() {
        guard let uid = Auth.auth().currentUser?.uid else { return  }
        print(uid)
        let db = Firestore.firestore().collection("Users").document(uid)
        db.getDocument {[weak self] (snapshot, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            guard let dictionary = snapshot?.data() else { return }
            self?.user = User(dictionary: dictionary)
            self?.loadUserPhotos()
            self?.tableView.reloadData()
        }
    }
    
    fileprivate func loadUserPhotos() {
        guard let imageUrl = user?.imageUrl1 , let url = URL(string: imageUrl) else { return }
        SDWebImageManager.shared().loadImage(with: url, options: .continueInBackground, progress: nil) { (image, _, error, _, _, _) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            self.imageBtn1.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        
    }
    
    fileprivate func setupNavigationItems() {
        navigationItem.title = "Settings"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handleCancel)),
            UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleCancel))
        ]
    }
    
    
    @objc fileprivate func handleCancel() {
        self.dismiss(animated: true)
    }
    
    lazy var header : UIView =  {
        let header = UIView()
        let rightStack = UIStackView(arrangedSubviews: [imageBtn2,imageBtn3])
        rightStack.axis = .vertical
        rightStack.distribution = .fillEqually
        rightStack.spacing = 8
        rightStack.translatesAutoresizingMaskIntoConstraints = false
        
        let parentStack = UIStackView(arrangedSubviews: [imageBtn1,rightStack])
        parentStack.axis = .horizontal
        parentStack.distribution = .fillEqually
        parentStack.spacing = 12
        parentStack.translatesAutoresizingMaskIntoConstraints = false
        header.addSubview(parentStack)
        parentStack.anchor(top: header.topAnchor, leading: header.leadingAnchor, bottom: header.bottomAnchor, trailing: header.trailingAnchor, padding: UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16))
        return header
    }()
    
    class HeaderLabel: UILabel {
        override func drawText(in rect: CGRect) {
            super.drawText(in: rect.insetBy(dx: 16, dy: 0))
        }
        
    }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 0 {
            return header
        }
        let headerLabel = HeaderLabel()
        headerLabel.font = UIFont.boldSystemFont(ofSize: 16)
        switch section {
        case 1:
            headerLabel.text = "Name"
        case 2:
            headerLabel.text = "Profession"
        case 3:
            headerLabel.text = "Age"
        default:
            headerLabel.text = "Bio"
        }
        return headerLabel
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 0 : 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = SettingsCell(style: .default, reuseIdentifier: nil)
        switch indexPath.section {
        case 1:
            cell.textField.placeholder = "Enter Name"
            cell.textField.text = user?.name
        case 2:
            cell.textField.placeholder = "Enter Profession"
            cell.textField.text = user?.profession
        case 3:
            cell.textField.placeholder = "Enter Age"
            if let age = user?.age {
                cell.textField.text = "\(age)"
            }
        default:
            cell.textField.placeholder = "Enter Bio"
        }
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 260
        }
        return 44
    }
    
}
