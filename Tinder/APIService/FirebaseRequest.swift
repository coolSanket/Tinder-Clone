//
//  FirebaseRequest.swift
//  Tinder
//
//  Created by sanket kumar on 20/01/19.
//  Copyright © 2019 sanket kumar. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class FirebaseRequest {
    
    // singleton
    static let shared = FirebaseRequest()
    
    
    func fetchCurrentUser(completion : @escaping (User) -> ()) {
        guard let uid = Auth.auth().currentUser?.uid else { return  }
        print("Firebase Request \(uid)")
        let db = Firestore.firestore().collection("Users").document(uid)
        db.getDocument {(snapshot, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            guard let dictionary = snapshot?.data() else { return }
            let user = User(dictionary: dictionary)
            completion(user)
        }
    }
    
}
