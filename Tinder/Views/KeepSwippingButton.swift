//
//  KeepSwippingButton.swift
//  Tinder
//
//  Created by sanket kumar on 20/02/19.
//  Copyright © 2019 sanket kumar. All rights reserved.
//

import UIKit

class KeepSwippingButton: UIButton {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
     */
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let gradientLayer = CAGradientLayer()
        let leftColor = #colorLiteral(red: 1, green: 0.01176470588, blue: 0.4470588235, alpha: 1)
        let rightColor = #colorLiteral(red: 1, green: 0.3921568627, blue: 0.3176470588, alpha: 1)
        gradientLayer.colors = [leftColor.cgColor,rightColor.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        
        let maskLayer = CAShapeLayer()
        let maskPath = CGMutablePath()
        
        let radius = rect.height / 2
        
        maskPath.addPath(UIBezierPath(roundedRect: rect, cornerRadius: radius).cgPath)
        maskPath.addPath(UIBezierPath(roundedRect: rect.insetBy(dx: 2, dy: 2), cornerRadius: radius).cgPath)
        
        maskLayer.path = maskPath
        maskLayer.fillRule = .evenOdd
        
        gradientLayer.mask = maskLayer
        
        self.layer.insertSublayer(gradientLayer, at: 0)
        gradientLayer.frame = rect
        layer.cornerRadius = radius
        clipsToBounds = true
        
    }
 

}
