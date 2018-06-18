//
//  Onboarding1View.swift
//  June
//
//  Created by Tatia Chachua on 04/10/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit

class PageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
 
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.clear
        
        dataSource = self
        delegate = self
        
        let onboardingView = Onboarding1View()
        onboardingView.imageName = imageNames.first
        let viewControllers = [onboardingView]
        setViewControllers(viewControllers, direction: .forward, animated: true, completion: nil)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        for view in self.view.subviews {
            if view is UIScrollView {
                view.frame = UIScreen.main.bounds
            } else if view is UIPageControl {
                view.backgroundColor = UIColor.clear
            }
        }
    }
    
    let imageNames = ["onboarding0", "onboarding1", "onboarding2", "onboarding3", "onboarding4"]
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        let currentImageName = (viewController as! Onboarding1View).imageName
        let currentIndex = imageNames.index(of: currentImageName!)
        
        if currentIndex! < imageNames.count - 1 {
            let onboardingView = Onboarding1View()
            onboardingView.imageName = imageNames[currentIndex! + 1]
            return onboardingView
        } else {
            dismiss(animated: true, completion: nil)
        }
        
        return nil
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
      
        setupPageControl()
        return  self.imageNames.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
    private func setupPageControl() {
        let appearance = UIPageControl.appearance()
        appearance.pageIndicatorTintColor = UIColor.gray
        appearance.currentPageIndicatorTintColor = UIColor.blue
        appearance.backgroundColor = UIColor.clear
       
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        return nil
    }
}

class Onboarding1View: UIViewController {
 
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.lightGray
        
        self.imageView.frame.size = CGSize(width: 375.0, height: 667.0)
        self.imageView.center = self.view.center
        
        self.view.addSubview(imageView)
   
    }
    let imageView: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "onboarding_1")
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    var imageName: String? {
        didSet {
            imageView.image = UIImage(named: imageName!)
        }
    }
   
}
