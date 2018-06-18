//
//  PHAsset+Extensions.swift
//  June
//
//  Created by Oksana Hanailiuk on 10/31/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import Photos

extension PHAsset {
    
    var originalFilename: String? {
        
        var fname:String?
        
        if #available(iOS 9.0, *) {
            let resources = PHAssetResource.assetResources(for: self)
            if let resource = resources.first {
                fname = resource.originalFilename
            }
        }
        
        if fname == nil {
            fname = self.value(forKey: "filename") as? String
        }
        
        return fname
    }
    
    var originalFileSize: Int32? {
        
        var sizeOnDisk: Int32? = 0
        
        if #available(iOS 9.0, *) {
            let resources = PHAssetResource.assetResources(for: self)
            if let resource = resources.first {
                let unsignedInt32 = resource.value(forKey: "fileSize") as? CLong
                sizeOnDisk = Int32(bitPattern: UInt32(unsignedInt32!))
            }
        }
        
        if sizeOnDisk == 0 {
            let unsignedInt32 = self.value(forKey: "fileSize") as? CLong
            sizeOnDisk = Int32(bitPattern: UInt32(unsignedInt32!))
        }
        
        return sizeOnDisk
    }
    
    var fileType: String? {
        
        var fileType:String?
        if let fileName = originalFilename {
            let array = fileName.split(separator: ".")
            if let last = array.last {
                fileType = "application/\(last.lowercased())"
            }
        }
        
        return fileType
    }
}
