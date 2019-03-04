//
//  Advertiser.swift
//  Tinder
//
//  Created by sanket kumar on 12/01/19.
//  Copyright © 2019 sanket kumar. All rights reserved.
//

import UIKit

struct Advertiser : CardViewModelProtocol {
    
    let title : String
    let brandName : String
    let posterPhotoName : String
    
    
    func toCardViewModel() -> CardViewModel {
        
        let attributedText = NSMutableAttributedString(string: title, attributes: [.font : UIFont.systemFont(ofSize: 24, weight: .heavy)])
        
        attributedText.append(NSAttributedString(string: "\n\(brandName)", attributes: [.font : UIFont.systemFont(ofSize: 14, weight: .regular)]))
        
        return CardViewModel(uid: "", imageUrls: [posterPhotoName], attributedString: attributedText, textAlignment: .center, bio: "")
        
    }
    
    
}


