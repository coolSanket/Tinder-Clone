//
//  SettingsCell.swift
//  Tinder
//
//  Created by sanket kumar on 19/01/19.
//  Copyright © 2019 sanket kumar. All rights reserved.
//

import UIKit

class SettingsCell: UITableViewCell {
    
    class SettingTextField: UITextField {
        
        override func textRect(forBounds bounds: CGRect) -> CGRect {
            return bounds.insetBy(dx: 16, dy: 0)
        }
        
        override func editingRect(forBounds bounds: CGRect) -> CGRect {
            return bounds.insetBy(dx: 16, dy: 0)
        }
        
        override var intrinsicContentSize: CGSize {
            return CGSize(width: 0, height: 44)
        }
    }
    
    let textField : SettingTextField = {
        let tf = SettingTextField()
        tf.placeholder = "Enter name"
        return tf
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        addSubview(textField)
        textField.fillSuperview()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
