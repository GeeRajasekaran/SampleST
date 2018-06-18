//
//  UIImageView+Extensions.swift
//  June
//
//  Created by Joshua Cleetus on 8/17/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit

typealias ImageDownloadCompletionBlock = (_ downloaded: Bool, _ error: Error?) -> ()

let imageCache = NSCache<NSString, UIImage>()

extension UIImageView {
    
    func loadImageUsingCacheWithURLString(_ URLString: String, placeHolder: UIImage?) {
        self.image = nil
        if let cachedImage = imageCache.object(forKey: NSString(string: URLString)) {
            self.image = cachedImage
            return
        }
        
        if let url = URL(string: URLString) {
            URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                
                if error != nil {
//                    print("ERROR LOADING IMAGES FROM URL: \(String(describing: error))")
                    DispatchQueue.main.async {
                        self.image = placeHolder
                    }
                    return
                }
                DispatchQueue.main.async {
                    if let data = data {
                        if let downloadedImage = UIImage(data: data) {
                            imageCache.setObject(downloadedImage, forKey: NSString(string: URLString))
                            self.image = downloadedImage
                        }
                    }
                }
            }).resume()
        }
    }
    
    func downloadedFrom(url: URL, contentMode mode: UIViewContentMode = .scaleAspectFit, completion: @escaping ImageDownloadCompletionBlock) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard
                let data = data, error == nil,
                let image = UIImage(data: data)
                else {
                    completion(false, error)
                    return
            }
            DispatchQueue.main.async() { () -> Void in
                self.image = image
                completion(true, nil)
            }
            }.resume()
        
    }
    
    func downloadedFrom(link: String, contentMode mode: UIViewContentMode = .scaleAspectFit, completion: @escaping ImageDownloadCompletionBlock) {
        guard let url = URL(string: link) else { return }
        downloadedFrom(url: url, contentMode: mode) { (downloaded, error) in
            completion(downloaded, error)
        }
    }
    
    // APPLY DROP SHADOW
    func applyShadow() {
        let layer           = self.layer
        layer.shadowColor   = UIColor.black.cgColor
        layer.shadowOffset  = CGSize(width: 0, height: 1)
        layer.shadowOpacity = 0.4
        layer.shadowRadius  = 2
    }
}
