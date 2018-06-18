//
//  ClipboardFileHandler.swift
//  June
//
//  Created by Oksana Hanailiuk on 10/30/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit
import MobileCoreServices

protocol ICloudFileHandlerDelegate: class {
    func handler(_ handler: ICloudFileHandler, didPickDocumentAt url: URL)
    func handler(_ handler: ICloudFileHandler, documentPickerWasCancelled controller: UIDocumentPickerViewController)
}

class ICloudFileHandler: NSObject, IFileHandler {
    
    weak var delegate: ICloudFileHandlerDelegate?
    
    let documentPickerController = UIDocumentPickerViewController(documentTypes: [String(kUTTypePDF), String(kUTTypeImage), String(kUTTypeMovie), String(kUTTypeVideo), String(kUTTypePlainText), String(kUTTypeMP3)], in: .import)
    
    func open(_ parentVC: UIViewController) {
        documentPickerController.delegate = self
        
        if let presentedVC = parentVC.presentedViewController {
            presentedVC.present(documentPickerController, animated: true, completion: nil)
        } else {
            parentVC.present(documentPickerController, animated: true, completion: nil)
        }
    }
}

extension ICloudFileHandler: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        delegate?.handler(self, didPickDocumentAt: url)
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        delegate?.handler(self, documentPickerWasCancelled: controller)
    }
}
