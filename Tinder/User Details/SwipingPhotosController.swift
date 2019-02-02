//
//  SwipingPhotosController.swift
//  Tinder
//
//  Created by sanket kumar on 02/02/19.
//  Copyright © 2019 sanket kumar. All rights reserved.
//

import UIKit

class SwipingPhotosController: UIPageViewController , UIPageViewControllerDataSource {
    
    
    var cardViewModel : CardViewModel! {
        didSet {
            print(cardViewModel.attributedString)
            controllers = cardViewModel.imageUrls.map({ (imageUrl) -> UIViewController in
                return PhotoController(imageUrl: imageUrl)
            })
            setViewControllers([controllers.first!], direction: UIPageViewController.NavigationDirection.forward, animated: true, completion: nil)
        }
    }
    
    var controllers = [UIViewController]() // empty

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        dataSource = self
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let index = self.controllers.firstIndex { (VC) -> Bool in
            return VC == viewController
            } ?? -1
        
        if index == 0 { return nil }
        return controllers[index - 1]
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let index = self.controllers.firstIndex { (VC) -> Bool in
            return VC == viewController
            } ?? -1
        
        if index == self.controllers.count - 1 { return nil }
        return controllers[index + 1]
    }
    

   
}

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
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
