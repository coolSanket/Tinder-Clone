//
//  User.swift
//  Tinder
//
//  Created by sanket kumar on 12/01/19.
//  Copyright © 2019 sanket kumar. All rights reserved.
//

import Foundation
import UIKit

struct User : CardViewModelProtocol {
    // define property
    var name : String?
    var age : Int?
    var profession : String?
//    let imageNames : [String]
    var imageUrl1 : String?
    var imageUrl2 : String?
    var imageUrl3 : String?
    var uid : String?
    var minSeekingAge : Int?
    var maxSeekingAge : Int?
    var bio : String?
    
    init(dictionary : [String : Any]) {
        // initialize user here
        self.age = dictionary["age"] as? Int
        self.profession = dictionary["profession"] as? String
        self.uid = dictionary["uid"] as? String ?? ""
        self.name = dictionary["fullName"] as? String ?? ""
        self.imageUrl1 = dictionary["imageUrl1"] as? String
        self.imageUrl2 = dictionary["imageUrl2"] as? String
        self.imageUrl3 = dictionary["imageUrl3"] as? String
        self.minSeekingAge = dictionary["minSeekingAge"] as? Int
        self.maxSeekingAge = dictionary["maxSeekingAge"] as? Int
        self.bio = dictionary["bio"] as? String
        
    }
    
    func toCardViewModel() -> CardViewModel {
        
        let attributedText = NSMutableAttributedString(string: name ?? "", attributes: [.font : UIFont.systemFont(ofSize: 24, weight: .heavy)])
        
        let ageString = age != nil ? "\(age!)" : "NA"
        
        attributedText.append(NSAttributedString(string: "  \(ageString)", attributes: [.font : UIFont.systemFont(ofSize: 18, weight: .regular)]))
        
        let professionString = profession != nil ? "\(profession!)" : "Not Available"
        attributedText.append(NSAttributedString(string: "\n\(professionString)", attributes: [.font : UIFont.systemFont(ofSize: 14, weight: .regular)]))
        
        let bioString = bio != nil ? "\(bio!)" : "Not Available"
    
        var imageUrls = [String]()
        if let url = imageUrl1 { imageUrls.append(url) }
        if let url = imageUrl2 { imageUrls.append(url) }
        if let url = imageUrl3 { imageUrls.append(url) }
        
        return CardViewModel(uid: self.uid ?? "", imageUrls: imageUrls, attributedString: attributedText, textAlignment: .left, bio: bioString)
        
    }
}


