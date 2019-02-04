//
//  PhotoController.swift
//  Tinder
//
//  Created by sanket kumar on 04/02/19.
//  Copyright © 2019 sanket kumar. All rights reserved.
//

import UIKit

class PhotoController: UIViewController {
    let imageView = UIImageView(image: #imageLiteral(resourceName: "lady4c"))
    
    init(imageUrl : String) {
        if let url = URL(string: imageUrl) {
            imageView.sd_setImage(with: url, completed: nil)
        }
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(imageView)
        imageView.fillSuperview()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


