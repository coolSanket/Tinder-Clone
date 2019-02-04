//
//  SwipingPhotosController.swift
//  Tinder
//
//  Created by sanket kumar on 02/02/19.
//  Copyright © 2019 sanket kumar. All rights reserved.
//

import UIKit

class SwipingPhotosController: UIPageViewController , UIPageViewControllerDataSource , UIPageViewControllerDelegate {
    
    
    var cardViewModel : CardViewModel! {
        didSet {
            print(cardViewModel.attributedString)
            controllers = cardViewModel.imageUrls.map({ (imageUrl) -> UIViewController in
                return PhotoController(imageUrl: imageUrl)
            })
            setViewControllers([controllers.first!], direction: UIPageViewController.NavigationDirection.forward, animated: true, completion: nil)
            setupBarViews()
        }
    }
    
    let barStackView = UIStackView(arrangedSubviews: [])
    let deselectedColor = UIColor(white: 0, alpha: 0.1)
    fileprivate func setupBarViews() {
        cardViewModel.imageUrls.forEach { (_) in
            let barView = UIView()
            barView.layer.cornerRadius = 3
            barView.backgroundColor = deselectedColor
            barStackView.addArrangedSubview(barView)
        }
        barStackView.arrangedSubviews.first?.backgroundColor = .white
        barStackView.spacing = 4
        barStackView.distribution = .fillEqually
        view.addSubview(barStackView)
        var paddingTop : CGFloat = 8
        if !isCardViewMode {
            paddingTop += UIApplication.shared.statusBarFrame.height
        }
        barStackView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: paddingTop, left: 8, bottom: 0, right: 8), size: CGSize(width: 0, height: 4))
    }
    
    var controllers = [UIViewController]() // empty

    fileprivate let isCardViewMode : Bool
    init(isCardViewMode : Bool = false) {
        self.isCardViewMode = isCardViewMode
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        dataSource = self
        delegate = self
        
        if isCardViewMode {
            disableSwipingAbility()
        }
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
    }
    
    @objc fileprivate func handleTap(gesture : UITapGestureRecognizer) {
        let currentController = viewControllers!.first!
        if let index = controllers.firstIndex(of: currentController) {
            if gesture.location(in: self.view).x > view.frame.width / 2 {
                let nextIndex = min(index + 1, controllers.count - 1)
                let nextController = controllers[nextIndex]
                setViewControllers([nextController], direction: .forward, animated: true)
                setupBarWhiteColor(index: nextIndex)
            }
            else {
                let prevIndex = max(index - 1, 0)
                let prevController = controllers[prevIndex]
                setViewControllers([prevController], direction: .reverse, animated: true)
                setupBarWhiteColor(index: prevIndex)
            }
        }
    }
    
    fileprivate func disableSwipingAbility() {
        view.subviews.forEach { (v) in
            if let v = v as? UIScrollView {
                v.isScrollEnabled = false
            }
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        print("Transition completed...")
        let currentPhotoController = viewControllers?.first
        if let index = controllers.lastIndex(where: {$0 == currentPhotoController }) {
            setupBarWhiteColor(index: index)
        }
        
        
    }
    
    fileprivate func setupBarWhiteColor(index : Int) {
        barStackView.arrangedSubviews.forEach({ $0.backgroundColor = deselectedColor })
        barStackView.arrangedSubviews[index].backgroundColor = .white
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let index = self.controllers.firstIndex { (VC) -> Bool in
            return VC == viewController
            } ?? -1
        
        if index <= 0 { return nil }
        return controllers[index - 1]
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let index = self.controllers.firstIndex { (VC) -> Bool in
            return VC == viewController
            } ?? -1
        
        if index >= self.controllers.count - 1 { return nil }
        return controllers[index + 1]
    }
    

   
}

