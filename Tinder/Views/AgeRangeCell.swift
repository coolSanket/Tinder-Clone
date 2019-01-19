//
//  AgeRangeCell.swift
//  Tinder
//
//  Created by sanket kumar on 19/01/19.
//  Copyright © 2019 sanket kumar. All rights reserved.
//

import UIKit

class AgeRangeCell: UITableViewCell {

    let minSlider : UISlider = {
        let slider = UISlider()
        slider.maximumValue = 100
        slider.minimumValue = 18
        return slider
    }()
    
    let maxSlider : UISlider = {
        let slider = UISlider()
        slider.maximumValue = 100
        slider.minimumValue = 18
        return slider
    }()
    
    let minLabel : UILabel = {
        let label = UILabel()
        label.text = "Min : 18"
        return label
    }()
    
    let maxLabel : UILabel = {
        let label = UILabel()
        label.text = "Max : 100"
        return label
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .white
        
        let labelStackView = UIStackView(arrangedSubviews: [minLabel,maxLabel])
        labelStackView.axis = .vertical
        labelStackView.spacing = 8
        labelStackView.distribution = .fillEqually

        let sliderStackView = UIStackView(arrangedSubviews: [minSlider,maxSlider])
        sliderStackView.spacing = 8
        sliderStackView.axis = .vertical
        sliderStackView.distribution = .fillEqually
        
        let stackView = UIStackView(arrangedSubviews: [
            labelStackView,
            sliderStackView
            ])
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        stackView.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
