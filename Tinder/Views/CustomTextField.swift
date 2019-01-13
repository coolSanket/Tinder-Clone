//
//  CustomTextField.swift
//  Tinder
//
//  Created by sanket kumar on 13/01/19.
//  Copyright © 2019 sanket kumar. All rights reserved.
//

import UIKit

class CustomTextField : UITextField {
    
    let padding : Int
    
    init(padding : Int) {
        self.padding = padding
        super.init(frame: .zero)
        layer.cornerRadius = 22
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: CGFloat(self.padding), dy: 0)
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: CGFloat(self.padding), dy: 0)
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 0, height: 44)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

