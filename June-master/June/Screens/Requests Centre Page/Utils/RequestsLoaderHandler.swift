//
//  RequestsLoaderHandler.swift
//  June
//
//  Created by Oksana Hanailiuk on 2/28/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import UIKit

class RequestsLoaderHandler: NSObject {
    
    private unowned var parentView: UIView
    private var loader: UIImageView?
    private var shouldShowLoader: Bool = true
    
    init(with parentView: UIView) {
        self.parentView = parentView
        
        let w = UIScreen.main.bounds.width
        let frame = CGRect(x: 0, y: 0, width: w, height: 5)
        loader = UIImageView(frame: frame)
        loader?.image = UIImage.gifImageWithName("gif_loader_iphoneX")
    }
    
    func  startLoader() {
        shouldShowLoader = true
//        startLoaderAnimation()
        perform(#selector(startLoaderAnimation), with: nil, afterDelay: 0.5)
    }
    
    func stopLoader() {
        shouldShowLoader = false
        stopLoaderAnimation()
    }
    
    @objc private func startLoaderAnimation() {
        if shouldShowLoader == false { return }
        if loader != nil {
            parentView.addSubviewIfNeeded(loader!)
        }
        
        //MARK: - stop after delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) { [weak self] in
            self?.stopLoader()
        }
    }
    
    private func stopLoaderAnimation() {
        if loader != nil {
            if loader?.superview != nil {
                loader?.removeFromSuperview()
            }
        }
    }
}
