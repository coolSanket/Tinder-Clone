//
//  Bindable.swift
//  Tinder
//
//  Created by sanket kumar on 14/01/19.
//  Copyright © 2019 sanket kumar. All rights reserved.
//

import Foundation
import UIKit

class Bindable<T> {
    
    var value : T? {
        didSet {
            observer?(value)
        }
    }
    
    var observer : ((T?)->())?
    
    func bind(observer : @escaping (T?) -> ()) {
        self.observer = observer
    }
    
}
