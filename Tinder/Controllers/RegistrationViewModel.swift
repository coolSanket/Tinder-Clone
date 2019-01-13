//
//  RegistrationViewModel.swift
//  Tinder
//
//  Created by sanket kumar on 13/01/19.
//  Copyright © 2019 sanket kumar. All rights reserved.
//

import UIKit

class RegistrationViewModel {
    
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
    
    fileprivate func checkFormValidity() {
        let isValid = name?.isEmpty == false && email?.isEmpty == false && password?.isEmpty == false
        formValidObserver?(isValid)
    }
    
    var formValidObserver : ((Bool) -> ())?
    
}
