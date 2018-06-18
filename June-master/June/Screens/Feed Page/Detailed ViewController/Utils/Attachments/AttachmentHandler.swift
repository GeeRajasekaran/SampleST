//
//  AttachmentHandler.swift
//  June
//
//  Created by Ostap Holub on 10/23/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit
import AlertBar

class AttachmentHandler: NSObject {
    
    // MARK: - Variables & Constants
    
    private unowned var rootViewController: UIViewController
    private var loader: AttachmentLoader
    private var interactionController: UIDocumentInteractionController?
    private var spinnerHandler = SpinnerProvider()
    
    // MARK: - Initialization
    
    init(with rootVC: UIViewController) {
        loader = AttachmentLoader()
        rootViewController = rootVC
    }
    
    deinit {
        spinnerHandler.stopSpinner()
    }
    
    // MARK: - Present logic
    
    func present(_ attachment: Attachment) {
        spinnerHandler.startSpinner()
        loader.download(attachment, completion: { [weak self] result in
            switch result {
            case .Success(let url):
                self?.spinnerHandler.stopSpinner()
                self?.showPreview(with: url)
            case .Error(let error):
                self?.spinnerHandler.stopSpinner()
                AlertBar.show(.error, message: error)
            }
        })
    }
    
    // MARK: - Private presenattion logic
    
    func showPreview(with urlString: String) {
        guard let url = URL(string: urlString) else {
            AlertBar.show(.error, message: "Invalid URL string")
            return
        }
        
        interactionController = UIDocumentInteractionController(url: url)
        interactionController?.delegate = self
        interactionController?.presentPreview(animated: true)
    }
}

extension AttachmentHandler: UIDocumentInteractionControllerDelegate {
    
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        if let presentedVC = rootViewController.presentedViewController {
            return presentedVC
        }
        return rootViewController
    }
}
