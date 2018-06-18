//
//  JuneImageView.swift
//  June
//
//  Created by Joshua Cleetus on 1/4/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import UIKit
import AlamofireImage
import Alamofire

enum JuneImageViewType {
    case circle
    case rounded
    case box
    
    var stringValue: String {
        get {
            switch self {
            case .box, .rounded:
                return "square-placeholder"
                
            case .circle:
                return "june_profile_pic_bg"
                
            }
        }
    }
}

class JuneImageView: UIView {

    var radius: CGFloat = 3 {
        didSet {
            imageView.layer.cornerRadius = radius
        }
    }
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    var viewType: JuneImageViewType
    
    init(viewType: JuneImageViewType = .rounded) {
        self.viewType = viewType
        super.init(frame: CGRect.zero)
        setupView()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not  been implemented")
    }
    
    internal func setupView() {
        backgroundColor = .clear
        
        imageView.image = UIImage(named: viewType.stringValue)
        addSubview(imageView)
    }
    
    internal func setupConstraints() {
        imageView.snp.remakeConstraints { (make) in
            make.size.equalTo(self)
            make.center.equalTo(self)
        }
    }
    
    func configureImage(with URLString: String, completionBlock: ((UIImage) -> Void)? = nil) {
        if let url = URL(string: URLString) {
            imageView.af_setImage(
                withURL: url,
                placeholderImage: UIImage(named: viewType.stringValue),
                filter: nil,
                imageTransition: .noTransition,
                runImageTransitionIfCached: true,
                completion: { (response) in
                    if let image = response.result.value  {
                        self.configueImage(withImage: image)
                        if let block = completionBlock {
                            block(image)
                        }
                    }
            })
        }
    }
    
    func configueImage(withImage image: UIImage) {
        let size = imageView.frame.size
        if size.height > 0 && size.width > 0 {
            let aspectScaledToFillImage = image.af_imageAspectScaled(toFill: size)
            switch viewType {
            case .circle:
                let finalImage = aspectScaledToFillImage.af_imageRoundedIntoCircle()
                imageView.image = finalImage
                
            case .rounded:
                let finalImage = aspectScaledToFillImage.af_imageRounded(withCornerRadius: radius)
                imageView.image = finalImage
                
            case .box:
                imageView.image = aspectScaledToFillImage
                
            }
        }
    }
    
    func configurePlaceholder() {
        imageView.image = UIImage(named: viewType.stringValue)
        imageView.contentMode = .scaleToFill
    }
    
    func configureBackground(color: UIColor) {
        imageView.image = nil
        backgroundColor = color
    }
    
    func configureImage(withAsset assetString: String) {
        imageView.image = UIImage(named: assetString)
        imageView.contentMode = .scaleAspectFit
    }

}
