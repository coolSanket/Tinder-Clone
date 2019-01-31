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

protocol SettingsControllerDelegate {
    func didSaveSetting()
}


class CustomImagePickerController: UIImagePickerController {
    var imageButton : UIButton?
}


class SettingsController: UITableViewController, UIImagePickerControllerDelegate , UINavigationControllerDelegate {

    var deletate : SettingsControllerDelegate?
    
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
        
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Uploading image..."
        hud.show(in: self.view)
        let fileName = UUID().uuidString
        let ref = Storage.storage().reference(withPath: "images/\(fileName)")
        guard let uploadData =  selectedImage?.jpegData(compressionQuality: 0.7) else { return }
        ref.putData(uploadData, metadata: nil) { (metadata, error) in
            
            if let error = error {
                hud.dismiss()
                print(error.localizedDescription)
                return
            }
            
            ref.downloadURL(completion: { [weak self] (url, error) in
                hud.dismiss()
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                print(url?.absoluteString ?? "")
                if imageButton == self?.imageBtn1 {
                    self?.user?.imageUrl1 = url?.absoluteString
                }
                else if imageButton == self?.imageBtn2 {
                    self?.user?.imageUrl2 = url?.absoluteString
                }else {
                    self?.user?.imageUrl3 = url?.absoluteString
                }
            })
            print("Finished uploading image..")
        }
        
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
        let shared = FirebaseRequest.shared
        shared.fetchCurrentUser(completion: {[weak self] (user) in
            self?.user = user
            self?.loadUserPhotos()
            self?.tableView.reloadData()
        })
    }
    
    fileprivate func loadUserPhotos() {
        setImages(button: imageBtn1, imageUrl: self.user?.imageUrl1)
        setImages(button: imageBtn2, imageUrl: self.user?.imageUrl2)
        setImages(button: imageBtn3, imageUrl: self.user?.imageUrl3)
    }
    
    fileprivate func setImages(button : UIButton, imageUrl : String?) {
        if  let imgUrl = imageUrl , let url = URL(string: imgUrl){
            SDWebImageManager.shared().loadImage(with: url, options: .continueInBackground, progress: nil) { (image, _, error, _, _, _) in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                button.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
            }
        }
    }
    
    fileprivate func setupNavigationItems() {
        navigationItem.title = "Settings"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handleSave)),
            UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        ]
    }
    
    @objc fileprivate func handleLogout() {
        try? Auth.auth().signOut()
        dismiss(animated: true, completion: nil)
    }
    
    @objc fileprivate func handleSave() {
        print("Saving data")
        guard let uid = Auth.auth().currentUser?.uid else { return  }
        let db = Firestore.firestore().collection("Users").document(uid)
        let documentData : [String : Any] = [
            "uid" : uid,
            "fullName" : user?.name ?? "",
            "imageUrl1" : user?.imageUrl1 ?? "",
            "imageUrl2" : user?.imageUrl2 ?? "",
            "imageUrl3" : user?.imageUrl3 ?? "",
            "age" : user?.age ?? -1,
            "profession" : user?.profession ?? "",
            "minSeekingAge" : user?.minSeekingAge ?? 18,
            "maxSeekingAge" : user?.maxSeekingAge ?? 35
        ]
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Saving Info"
        hud.show(in: self.view)
        db.setData(documentData) { (error) in
            if let error = error {
                print("failed to save data : \(error.localizedDescription)")
                return
            }
            hud.dismiss()
            print("user info saved..")
            
            self.dismiss(animated: true, completion: {
                print("Settings controller dismissed")
                self.deletate?.didSaveSetting()
            })
        }
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
        case 4:
            headerLabel.text = "Bio"
        default:
            headerLabel.text = "Seeking Age Range"
        }
        return headerLabel
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 6
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 0 : 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 5 {
            let ageRangeCell = AgeRangeCell(style: .default, reuseIdentifier: nil)
            ageRangeCell.minSlider.addTarget(self, action: #selector(handleMinSliderValueChanged), for: .valueChanged)
            ageRangeCell.maxSlider.addTarget(self, action: #selector(handleMaxSliderValueChanged), for: .valueChanged)
            ageRangeCell.minLabel.text = "Min : \(user?.minSeekingAge ?? 18)"
            ageRangeCell.maxLabel.text = "Max : \(user?.maxSeekingAge ?? 35)"
            ageRangeCell.minSlider.setValue(Float(user?.minSeekingAge ?? 18), animated: true)
            ageRangeCell.maxSlider.setValue(Float(user?.maxSeekingAge ?? 35), animated: true)
            return ageRangeCell
        }
        
        
        let cell = SettingsCell(style: .default, reuseIdentifier: nil)
        switch indexPath.section {
        case 1:
            cell.textField.placeholder = "Enter Name"
            cell.textField.text = user?.name
            cell.textField.addTarget(self, action: #selector(handleNameChange), for: .editingChanged)
        case 2:
            cell.textField.placeholder = "Enter Profession"
            cell.textField.text = user?.profession
            cell.textField.addTarget(self, action: #selector(handleProfessionChange), for: .editingChanged)
        case 3:
            cell.textField.placeholder = "Enter Age"
            cell.textField.addTarget(self, action: #selector(handleAgeChange), for: .editingChanged)
            if let age = user?.age {
                cell.textField.text = "\(age)"
            }
        default:
            cell.textField.placeholder = "Enter Bio"
        }
        return cell
    }
    
    @objc fileprivate func handleMinSliderValueChanged(slider : UISlider) {
        print(slider.value)
        let indexPath = IndexPath(row: 0, section: 5)
        let ageRangeCell = tableView.cellForRow(at: indexPath) as! AgeRangeCell
        ageRangeCell.minLabel.text = "Min : \(Int(slider.value))"
        self.user?.minSeekingAge = Int(slider.value)
        if slider.value > ageRangeCell.maxSlider.value {
            ageRangeCell.maxSlider.setValue(slider.value, animated: true)
            ageRangeCell.maxLabel.text = "Max : \(Int(slider.value))"
        }
        
    }
    
    @objc fileprivate func handleMaxSliderValueChanged(slider : UISlider) {
        print(slider.value)
        let indexPath = IndexPath(row: 0, section: 5)
        let ageRangeCell = tableView.cellForRow(at: indexPath) as! AgeRangeCell
        ageRangeCell.maxLabel.text = "Max : \(Int(slider.value))"
        self.user?.maxSeekingAge = Int(slider.value)
    }
    
    
    @objc fileprivate func handleNameChange(textField : UITextField) {
        self.user?.name = textField.text
    }
    
    @objc fileprivate func handleProfessionChange(textField : UITextField) {
        self.user?.profession = textField.text
    }
    
    @objc fileprivate func handleAgeChange(textField : UITextField) {
        self.user?.age = Int(textField.text ?? "-1")
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 260
        }
        return 44
    }
    
}
