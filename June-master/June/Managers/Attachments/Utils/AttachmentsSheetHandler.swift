//
//  AttachmentsSheetHandler.swift
//  June
//
//  Created by Oksana Hanailiuk on 10/30/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit
import Photos
import SwiftyJSON
import MobileCoreServices

protocol AttachmentsSheetHandlerDelegate: class {
    func handler(_ handler: AttachmentsSheetHandler, dismissWith attachment: Attachment)
    func handler(_ handler: AttachmentsSheetHandler, didPressCancel cancelButton: UIButton?)
    func handler(_ handler: AttachmentsSheetHandler, startUploadingImage isUploading: Bool)
    
    func handler(_ handler: AttachmentsSheetHandler, didFailWith error: String)
}

class AttachmentsSheetHandler: NSObject, UINavigationControllerDelegate {
    
    private var actionSheet: UIAlertController?
    private var presentingVC: UIViewController?
    
    private var imagePicker = UIImagePickerController()
    private var proxy = FilesProxy()
    private var parser = AttachmentsParser()
    private var fileHandler: ICloudFileHandler?
    private weak var delegate: AttachmentsSheetHandlerDelegate?
    private var spinnerProvider = SpinnerProvider()
    private var engine = UploadEngine()
    
    private let imageType: String = "public.image"
    private let videoType: String = "public.movie"
    
    // MARK: - Initialization
    
    init(with vc: UIViewController) {
        super.init()
        presentingVC = vc
        buildActionSheet()
    }
    
    init(with vc: UIViewController, andCallback delegate: AttachmentsSheetHandlerDelegate) {
        super.init()
        presentingVC = vc
        self.delegate = delegate
        buildActionSheet()
    }
    
    // MARK: - Public part
    
    func show() {
        guard let sheet = actionSheet else { return }
        if let presentedVC = presentingVC?.presentedViewController {
            presentedVC.present(sheet, animated: true, completion: nil)
        } else {
            presentingVC?.present(sheet, animated: true, completion: nil)
        }
    }
    
    // MARK: - Private part
    
    private func openGallary() {
        guard let mediaType = UIImagePickerController.availableMediaTypes(for: .photoLibrary) else { return }
        imagePicker.sourceType = .photoLibrary
        imagePicker.navigationBar.barTintColor = .white
        imagePicker.mediaTypes = mediaType
        imagePicker.delegate = self
        if let presentedVC = presentingVC?.presentedViewController {
            presentedVC.present(imagePicker, animated: true, completion: nil)
        } else {
            presentingVC?.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    private func takePhoto() {
        guard let mediaType = UIImagePickerController.availableMediaTypes(for: .camera) else { return }
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.mediaTypes = mediaType
        if let presentedVC = presentingVC?.presentedViewController {
            presentedVC.present(imagePicker, animated: true, completion: nil)
        } else {
            presentingVC?.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    private func openDocumentDirectory() {
        fileHandler = ICloudFileHandler()
        fileHandler?.delegate = self
        guard let vc = self.presentingVC else { return }
        fileHandler?.open(vc)
    }
    
    // MARK: - Actions
    
    lazy var galleryAction: (() -> Void) = {
        self.openGallary()
    }
    
    lazy var cameraAction: (() -> Void) = {
        self.takePhoto()
    }
    
    lazy var fileAction: (() -> Void) = {
        self.openDocumentDirectory()
    }
    
    private func buildActionSheet() {
        actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let openCameraAction = UIAlertAction(title: LocalizedStringKey.AttachmentViewHelper.CameraTitle, style: .default, handler: { _ in self.cameraAction() })
        let openGallery = UIAlertAction(title: LocalizedStringKey.AttachmentViewHelper.GalleryTitle, style: .default, handler: { _ in self.galleryAction() })
        let openFileDirectory = UIAlertAction(title: LocalizedStringKey.AttachmentViewHelper.FileTitle, style: .default, handler: { _ in self.fileAction() })
        let cancelAction = UIAlertAction(title: LocalizedStringKey.AttachmentViewHelper.CancelTitle, style: .cancel, handler: { _ in
            self.delegate?.handler(self, didPressCancel: nil)
        })
        
        actionSheet?.addAction(openCameraAction)
        actionSheet?.addAction(openGallery)
        actionSheet?.addAction(openFileDirectory)
        actionSheet?.addAction(cancelAction)
    }
    
    //API call
    func upload(imageData: Data?, with imageName: String?, and fileURL: URL?, mimeType: String = "image/jpg") {
        spinnerProvider.startSpinner()
        NotificationCenter.default.post(name: .onStartUploading, object: nil)
        delegate?.handler(self, startUploadingImage: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) { [weak self] in
            if let sSelf = self {
                sSelf.spinnerProvider.stopSpinner()
            }
        }
        
        engine.upload(imageData: imageData, with: imageName, and: fileURL, mimeType: mimeType, onCompletion: { [weak self] json in
            guard let sSelf = self else { return }
            sSelf.spinnerProvider.stopSpinner()
            NotificationCenter.default.post(name: .onStopUploading, object: nil)
            guard let unwrappedJson = json else { return }
            let attachment = Attachment(jsonObject: unwrappedJson["uploaded"])
            sSelf.saveAttachment(unwrappedJson)
            sSelf.delegate?.handler(sSelf, dismissWith: attachment)
        }) { (error) in
            NotificationCenter.default.post(name: .onStopUploading, object: nil)
            self.spinnerProvider.stopSpinner()
        }
    }
    
    //MARK: - save attachment into core data
    func saveAttachment(_ json: JSON) {
        guard let attachmentId = json["id"].string else { return }
        if let attachmentEntity = proxy.fetchFile(by: attachmentId) {
            parser.loadData(from: json, to: attachmentEntity)
        } else {
            let attachment = proxy.addNewEmptyFiles()
            parser.loadData(from: json, to: attachment)
        }
        proxy.saveContext()
    }
}

extension AttachmentsSheetHandler: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var imageName = "Image Uploaded from iOS.jpg"
        if let imageURL = info[UIImagePickerControllerReferenceURL] as? URL {
            let result = PHAsset.fetchAssets(withALAssetURLs: [imageURL], options: nil)
            let asset = result.firstObject
            guard let assetName = asset?.originalFilename else { return }
            imageName = assetName
        }
        
        var uploadData: Data?
        var mimeType: String = "image/jpg"
        if let mediaType = info[UIImagePickerControllerMediaType] as? String  {
            if mediaType == imageType {
                uploadData = imageBinaryData(from: info)
            } else if mediaType == videoType {
                uploadData = videoBinaryData(from: info)
                if let url = info[UIImagePickerControllerMediaURL] as? URL {
                    mimeType = type(from: url)
                }
            }
            presentingVC?.dismiss(animated: true, completion: nil)
            if isValidSize(of: uploadData) {
                upload(imageData: uploadData, with: imageName, and: nil, mimeType: mimeType)
            } else {
                delegate?.handler(self, didFailWith: LocalizedStringKey.ResponderHelper.FileTooLarge)
            }
        } else {
            presentingVC?.dismiss(animated: true, completion: nil)
            delegate?.handler(self, didFailWith: LocalizedStringKey.ResponderHelper.UnsupportedTypeError)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        presentingVC?.dismiss(animated:true, completion: nil)
        delegate?.handler(self, didPressCancel: nil)
    }
    
    // MARK: - Private processing logic
    
    private func imageBinaryData(from info: [String: Any]) -> Data? {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            return UIImageJPEGRepresentation(image, 0.1)
        } else {
            presentingVC?.dismiss(animated: true, completion: nil)
            delegate?.handler(self, didFailWith: LocalizedStringKey.ResponderHelper.InvalidImage)
        }
        return nil
    }
    
    private func videoBinaryData(from info: [String: Any]) -> Data? {
        if let url = info[UIImagePickerControllerMediaURL] as? URL {
            do {
                return try Data(contentsOf: url)
            } catch (let error) {
                presentingVC?.dismiss(animated: true, completion: nil)
                delegate?.handler(self, didFailWith: error.localizedDescription)
            }
        }
        return nil
    }
    
    private func type(from url: URL) -> String {
        let pathExtension = url.pathExtension
        if let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, pathExtension as NSString, nil)?.takeRetainedValue() {
            if let mimetype = UTTypeCopyPreferredTagWithClass(uti, kUTTagClassMIMEType)?.takeRetainedValue() {
                return mimetype as String
            }
        }
        return "application/octet-stream"
    }
    
    private func isValidSize(of data: Data?) -> Bool {
        guard let count = data?.count else { return false }
        return count <= 26214400
    }
}

extension AttachmentsSheetHandler: ICloudFileHandlerDelegate {
    func handler(_ handler: ICloudFileHandler, didPickDocumentAt url: URL) {
        upload(imageData: nil, with: nil, and: url)
    }
    
    func handler(_ handler: ICloudFileHandler, documentPickerWasCancelled controller: UIDocumentPickerViewController) {
        delegate?.handler(self, didPressCancel: nil)
    }
}
