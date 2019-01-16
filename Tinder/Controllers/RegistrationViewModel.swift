//
//  RegistrationViewModel.swift
//  Tinder
//
//  Created by sanket kumar on 13/01/19.
//  Copyright © 2019 sanket kumar. All rights reserved.
//

import UIKit
import Firebase

class RegistrationViewModel {
    
    var bindableIsRegistering = Bindable<Bool>()
    var bindableImage = Bindable<UIImage>()
    var bindableIsFormValid = Bindable<Bool>()

    
    var name : String?  {
        didSet {
            checkFormValidity()
        }
    }
    var email : String? {
        didSet {
            checkFormValidity()
        }
    }
    var password : String? {
        didSet {
            checkFormValidity()
        }
    }
    
    
    func performRegistration(completion : @escaping (Error?) -> ()) {
        guard let email = email else { return  }
        guard let password = password else { return }
        bindableIsRegistering.value = true
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if let error = error {
                completion(error)
                return
            }
            print("Successfully registered with id : \(user?.uid ?? "")")
            self.saveImageToFirebase(completion: completion)
        }
    }
    
    
    func saveImageToFirebase(completion : @escaping (Error?) -> ()) {
        // upload image if user is registered
        let filePath = UUID().uuidString
        let imageData = self.bindableImage.value?.jpegData(compressionQuality: 0.75) ?? Data()
        let ref = Storage.storage().reference(withPath: "images/\(filePath)")
        ref.putData(imageData, metadata: nil, completion: { (_, error) in
            if let error = error {
                completion(error)
                return
            }
            print("Successfully uploaded image...")
            ref.downloadURL(completion: { (url, error) in
                if let error = error {
                    completion(error)
                    return
                }
                self.bindableIsRegistering.value = false
                print("Download url of image : \(url?.absoluteString ?? "")")
                // Store download url into firestore
                let imageUrl = url?.absoluteString ?? ""
                self.saveInfoToFirestore(imageUrl: imageUrl, completion: completion)
            })
            
        })
    }
    
    fileprivate func saveInfoToFirestore(imageUrl : String,completion : @escaping (Error?) -> ()) {
        let uid = Auth.auth().currentUser?.uid ?? ""
        
        let docData = ["fullName" : name ?? "",
                       "uid" : uid,
                       "imageUrl1" : imageUrl]
        
        let db = Firestore.firestore()
        db.collection("Users").document(uid).setData(docData) { (error) in
            if let error = error {
                completion(error)
                return
            }
            print("Successfully saved in firestore")
            completion(nil)
        }
        
    }
    
    
    fileprivate func checkFormValidity() {
        let isValid = name?.isEmpty == false && email?.isEmpty == false && password?.isEmpty == false
        bindableIsFormValid.value = isValid

    }

    
    
    
}
