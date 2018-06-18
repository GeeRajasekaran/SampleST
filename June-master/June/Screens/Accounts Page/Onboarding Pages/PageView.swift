//
//  PageView.swift
//  June
//
//  Created by Tatia Chachua on 06/03/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import UIKit

class PageView: UIPageViewController {
    
    var viewNames = [Page1View(), Page2View(), Page3View(), Page4View(), Page5View()]

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.clear

        let viewControllers = [self.viewNames[0]]
        setViewControllers(viewControllers, direction: .forward, animated: true, completion: nil)
        
        UIApplication.shared.registerForRemoteNotifications()
    }
    
    @objc func onboard1ButtonPressed() {
        let currentImageName = (viewNames[1] )
        let viewControllers = [currentImageName]
        setViewControllers(viewControllers, direction: .forward, animated: true, completion: nil)
    }
    
    @objc func onboard2ButtonPressed() {
        let currentImageName = (viewNames[2] )
        let viewControllers = [currentImageName]
        setViewControllers(viewControllers, direction: .forward, animated: true, completion: nil)
    }
    
    @objc func onboard3ButtonPressed() {
        let currentImageName = (viewNames[3] )
        let viewControllers = [currentImageName]
        setViewControllers(viewControllers, direction: .forward, animated: true, completion: nil)
    }
    
    @objc func onboard4ButtonPressed() {
        let currentImageName = (viewNames[4] )
        let viewControllers = [currentImageName]
        setViewControllers(viewControllers, direction: .forward, animated: true, completion: nil)
    }
    
    @objc func onboard5ButtonPressed() {
        dismiss(animated: true, completion: nil)
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

}
// MARK: - Page 1
class Page1View: UIViewController {
 
    let imageView: UIImageView = {
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    let image = UIImageView()
    let gettStartedBtn = UIButton()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.lightGray
        self.view.isUserInteractionEnabled = true
        
        self.imageView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        self.imageView.center = self.view.center
        self.imageView.isUserInteractionEnabled = true
        self.view.addSubview(imageView)
        
        self.image.frame = CGRect(x: -7, y: -7, width: 339, height: 69)
        self.image.image = #imageLiteral(resourceName: "onboard_1_button")
        
        let pageView = PageView()
        
        self.gettStartedBtn.frame = CGRect(x: 25, y: 418, width: 326, height: 55)
        self.imageView.image = #imageLiteral(resourceName: "onboard_1_normal")
       
        let plusSize = 414
        if Int(self.view.frame.size.width) == plusSize {
            print("This is iPhone Plus size device")
            self.imageView.image = UIImage(named: "onboard_1_plus")
            self.gettStartedBtn.frame = CGRect(x: 44, y: 460, width: 326, height: 55)
        }
        
        if #available(iOS 11.0, *) {
            if let insets = (UIApplication.shared.delegate as? AppDelegate)?.window?.safeAreaInsets {
                if insets.top > 0 {
                    // It's iPhone X
                    print("This is iPhone X")
                    self.imageView.image = UIImage(named: "onboard_1")
                    self.gettStartedBtn.frame = CGRect(x: 24, y: 518, width: self.view.frame.size.width - 49, height: 55)

                }
            }
        }
        self.gettStartedBtn.backgroundColor = .clear
        self.gettStartedBtn.isUserInteractionEnabled = true
        self.gettStartedBtn.addTarget(pageView, action: #selector(pageView.onboard1ButtonPressed), for: .touchUpInside)
        self.gettStartedBtn.clipsToBounds = true
        self.gettStartedBtn.contentMode = .scaleAspectFill
        self.imageView.addSubview(gettStartedBtn)
        self.gettStartedBtn.addSubview(image)
    }

}

// MARK: - Page 2
class Page2View: UIViewController {

    let imageView: UIImageView = {
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    let image = UIImageView()
    let button = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.lightGray
        self.view.isUserInteractionEnabled = true
        
        self.imageView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        self.imageView.center = self.view.center
        self.imageView.isUserInteractionEnabled = true
        self.view.addSubview(imageView)
        
        let pageView = PageView()
        
        imageView.image = #imageLiteral(resourceName: "onboard_2_normal")
        image.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        image.image = #imageLiteral(resourceName: "onboard_3_button")
        
        self.button.frame = CGRect(x: 305, y: 597, width: 50, height: 50)
        
        let plusSize = 414
        if Int(self.view.frame.size.width) == plusSize {
            self.imageView.image = UIImage(named: "onboard_2_plus")
            self.button.frame = CGRect(x: 341, y: 663, width: 50, height: 50)
        }
        
        if #available(iOS 11.0, *) {
            if let insets = (UIApplication.shared.delegate as? AppDelegate)?.window?.safeAreaInsets {
                if insets.top > 0 {
                    // It's iPhone X
                    self.imageView.image = UIImage(named: "onboard_2")
                    self.button.frame = CGRect(x: 303, y: 724, width: 50, height: 50)
                    
                }
            }
        }
        
        self.button.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0)
        self.button.backgroundColor = .clear
        self.button.isUserInteractionEnabled = true
        self.button.addTarget(pageView, action: #selector(pageView.onboard2ButtonPressed), for: .touchUpInside)
        self.button.clipsToBounds = true
        self.button.contentMode = .scaleAspectFill
        self.button.addSubview(image)
        self.imageView.addSubview(button)
    }
    
}

// MARK: - Page 3
class Page3View: UIViewController {
    
    let imageView: UIImageView = {
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    let image = UIImageView()
    let button = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.lightGray
        self.view.isUserInteractionEnabled = true
        
        self.imageView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        self.imageView.center = self.view.center
        self.imageView.isUserInteractionEnabled = true
        self.view.addSubview(imageView)
        
        let pageView = PageView()
        
        self.imageView.image = #imageLiteral(resourceName: "onboard_3_normal")
        image.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        image.image = #imageLiteral(resourceName: "onboard_3_button")
        
        self.button.frame = CGRect(x: 305, y: 597, width: 50, height: 50)

        let plusSize = 414
        if Int(self.view.frame.size.width) == plusSize {
            self.imageView.image = UIImage(named: "onboard_3_plus")
            self.button.frame = CGRect(x: 341, y: 663, width: 50, height: 50)
        }
        
        if #available(iOS 11.0, *) {
            if let insets = (UIApplication.shared.delegate as? AppDelegate)?.window?.safeAreaInsets {
                if insets.top > 0 {
                    // It's iPhone X
                    self.imageView.image = UIImage(named: "onboard_3")
                    self.button.frame = CGRect(x: 303, y: 724, width: 50, height: 50)
                    
                }
            }
        }
        self.button.contentEdgeInsets = UIEdgeInsetsMake(-5, 0, 0, 0)
        self.button.backgroundColor = .clear
        self.button.isUserInteractionEnabled = true
        self.button.addTarget(pageView, action: #selector(pageView.onboard3ButtonPressed), for: .touchUpInside)
        self.button.clipsToBounds = true
        self.button.contentMode = .scaleAspectFill
        self.button.addSubview(image)
        self.imageView.addSubview(button)
        
    }
    
}

// MARK: - Page 4
class Page4View: UIViewController {
    
    let imageView: UIImageView = {
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    let image = UIImageView()
    let button = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.lightGray
        self.view.isUserInteractionEnabled = true
        
        self.imageView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        self.imageView.center = self.view.center
        self.imageView.isUserInteractionEnabled = true
        self.view.addSubview(imageView)
        
        let pageView = PageView()
        
        self.imageView.image = #imageLiteral(resourceName: "onboard_4_normal")
        image.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        image.image = #imageLiteral(resourceName: "onboard_4_button")
        
        self.button.frame = CGRect(x: 305, y: 597, width: 50, height: 50)
    
        
        let plusSize = 414
        if Int(self.view.frame.size.width) == plusSize {
            self.imageView.image = UIImage(named: "onboard_4_plus")
            self.button.frame = CGRect(x: 341, y: 663, width: 50, height: 50)
        }
        
        if #available(iOS 11.0, *) {
            if let insets = (UIApplication.shared.delegate as? AppDelegate)?.window?.safeAreaInsets {
                if insets.top > 0 {
                    // It's iPhone X
                    self.imageView.image = UIImage(named: "onboard_4")
                    self.button.frame = CGRect(x: 303, y: 724, width: 50, height: 50)
                }
            }
        }
        self.button.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0)
        self.button.backgroundColor = .clear
        self.button.isUserInteractionEnabled = true
        self.button.addTarget(pageView, action: #selector(pageView.onboard4ButtonPressed), for: .touchUpInside)
        self.button.clipsToBounds = true
        self.button.contentMode = .scaleAspectFill
        self.button.addSubview(image)
        self.imageView.addSubview(button)
        
    }
    
}

// MARK: - Page 5
class Page5View: UIViewController {
    
    let imageView: UIImageView = {
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    let image = UIImageView()
    let button = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.lightGray
        self.view.isUserInteractionEnabled = true
        
        self.imageView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        self.imageView.center = self.view.center
        self.imageView.isUserInteractionEnabled = true
        self.view.addSubview(imageView)
        
        let pageView = PageView()
        
        self.imageView.image = #imageLiteral(resourceName: "onboard_5_normal")
        image.frame = CGRect(x: 0, y: 0, width: 323, height: 55)
        image.image = #imageLiteral(resourceName: "onboard_5_button")
        
        self.button.frame = CGRect(x: 25, y: 532, width: 326, height: 55)
        
        let plusSize = 414
        if Int(self.view.frame.size.width) == plusSize {
            self.imageView.image = UIImage(named: "onboard_5_plus")
            self.button.frame = CGRect(x: 44, y: 552, width: 326, height: 55)
        }
        
        if #available(iOS 11.0, *) {
            if let insets = (UIApplication.shared.delegate as? AppDelegate)?.window?.safeAreaInsets {
                if insets.top > 0 {
                    // It's iPhone X
                    self.imageView.image = UIImage(named: "onboard_5")
                    self.button.frame = CGRect(x: 24, y: 597, width: 326, height: 55)
                    
                }
            }
        }

        self.button.backgroundColor = .clear
        self.button.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0)
        self.button.isUserInteractionEnabled = true
        self.button.addTarget(pageView, action: #selector(pageView.onboard5ButtonPressed), for: .touchUpInside)
        self.button.clipsToBounds = true
        self.button.contentMode = .scaleAspectFill
        self.button.addSubview(image)
        self.imageView.addSubview(button)
    }
    
}
