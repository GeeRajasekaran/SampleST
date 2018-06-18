//
//  CustomLoader.swift
//  June
//
//  Created by Joshua Cleetus on 2/27/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class CustomLoader: UIView, NVActivityIndicatorViewable {
    
    var loaderView: NVActivityIndicatorView?
    var loaderBgView: UIImageView = UIImageView()
    var label: UILabel = UILabel()
    var gifImageView: UIImageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.startLoader()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func  startLoader() {
        let w = UIScreen.main.bounds.width
        let h = UIScreen.main.bounds.height
        
        self.loaderBgView.frame = CGRect(x: 0, y: 0, width: w, height: h)
        self.loaderBgView.backgroundColor = UIColor.white
        self.addSubview(self.loaderBgView)
        
        let loaderFrame = CGRect.init(x: (w/2) - 25, y: (h/2) - 140, width: 40, height: 30)
        self.loaderView = NVActivityIndicatorView(frame: loaderFrame, type: .ballBeat, color: UIColor.init(hexString: "8A8A8A"), padding: 0)
        if let loader = self.loaderView {
            self.loaderBgView.addSubview(loader)
        }
        
        self.gifImageView.frame = CGRect(x: 0, y: 0, width: w, height: 5)
        let joshGif = UIImage.gifImageWithName("gif_loader_iphoneX")
        self.gifImageView.image = joshGif
        self.gifImageView.contentMode = .scaleAspectFill
        self.gifImageView.clipsToBounds = true
        self.addSubview(self.gifImageView)
        
        label.frame = CGRect(x: 0, y: (h/2) - 100, width: w, height: 25)
        label.textAlignment = .center
        label.textColor = UIColor.init(hexString: "8A8A8A")
        label.text = "Loading..."
        self.addSubview(label)
        
    }

}
