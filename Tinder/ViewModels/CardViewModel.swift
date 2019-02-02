//
//  CardViewModel.swift
//  Tinder
//
//  Created by sanket kumar on 12/01/19.
//  Copyright © 2019 sanket kumar. All rights reserved.
//

import UIKit


protocol CardViewModelProtocol {
    func toCardViewModel() -> CardViewModel
}


struct  CardViewModel {
    
    // define the property
    let imageUrls : [String]
    let attributedString : NSAttributedString
    let textAlignment : NSTextAlignment
    
    
}


