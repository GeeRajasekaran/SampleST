//
//  FavoritesViewController.swift
//  June
//
//  Created by Tatia Chachua on 04/01/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import UIKit

class FavoritesViewController: UIViewController {
    
    let starImage: UIImageView = UIImageView()
    let comingSoonLabel: UILabel = UILabel()
    let lineView: UIView = UIView()
    var screenBuilder: ConvosScreenBuilder = ConvosScreenBuilder(model: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.view.backgroundColor = .clear
        
        self.lineView.frame = CGRect(x: 0, y: 0.2786666666 * self.view.frame.size.width, width: self.view.frame.size.width, height: 1)
        self.lineView.backgroundColor = UIColor(":CBCECE")
        self.view.addSubview(lineView)
        
        setupSubviews()
    }
  
    func setupSubviews() {
        
        self.starImage.frame = CGRect(x: 0.408 * self.view.frame.size.width, y: CGFloat(self.view.frame.size.height / 2) - 130, width: 0.20266666 * self.view.frame.size.width, height: 0.186666666 * self.view.frame.size.width)
        self.starImage.image = #imageLiteral(resourceName: "starImage")
        self.view.addSubview(self.starImage)
    
        self.comingSoonLabel.frame = CGRect(x: 108, y:  Int(self.view.frame.size.height / 2) - 46, width: 162, height: 34)
        self.comingSoonLabel.text = Localized.string(forKey: LocalizedString.FavoritesViewComingSoonLabelTotle)
        self.comingSoonLabel.textColor = UIColor(":28282C")
        self.comingSoonLabel.font = UIFont.latoStyleAndSize(style: .regular, size: .extraLarge)
        self.view.addSubview(comingSoonLabel)
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.title = "Favorites"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.title = ""
    }
    
    override func loadViewIfNeeded() {
        
    }
   
}

