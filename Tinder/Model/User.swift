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
    let name : String
    let age : Int
    let profession : String
    let imageName : String
    
    
    func toCardViewModel() -> CardViewModel {
        
        let attributedText = NSMutableAttributedString(string: name, attributes: [.font : UIFont.systemFont(ofSize: 24, weight: .heavy)])
        attributedText.append(NSAttributedString(string: "  \(age)", attributes: [.font : UIFont.systemFont(ofSize: 18, weight: .regular)]))
        attributedText.append(NSAttributedString(string: "\n\(profession)", attributes: [.font : UIFont.systemFont(ofSize: 14, weight: .regular)]))
        
        return CardViewModel(imageName: imageName, attributedString: attributedText, textAlignment: .left)
        
    }
}


