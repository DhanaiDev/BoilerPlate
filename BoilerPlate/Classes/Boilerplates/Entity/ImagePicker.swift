//
//  ImagePicker.swift
//  BoilerPlate
//
//  Created by dhanasekaran on 17/08/21.
//

import UIKit
import AVFoundation
import Photos

typealias PhotoLibraryRequestCompletion =  ((Bool) -> Void)

class RequestAccessHandler {
    static func canOpenPhotos(_ completion: PhotoLibraryRequestCompletion?, for viewController : UIViewController?) {
        func showDeniedAlert() {
            DispatchQueue.main.async {
                showSettingsAlert(title: nil, message: Strings.photoPermissionDenied, completion: completion, viewController: viewController)
            }
        }
        
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .authorized:
            complete(completion, value:true)
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { (status) in
                if status == .authorized {
                    complete(completion, value:true)
                } else {
                    showDeniedAlert()
                }
            }
        case .restricted:
            complete(completion, value:false)
        case .denied:
            showDeniedAlert()
        default:
            break
        }
    }


    static func canOpenCamera(for mediaType: AVMediaType,_ completion: PhotoLibraryRequestCompletion?, for viewController : UIViewController?) {
        func showDeniedAlert() {
            DispatchQueue.main.async {
                showSettingsAlert(title: nil, message: Strings.cameraPermissionDenied, completion: completion, viewController: viewController)
            }
        }
        let status = AVCaptureDevice.authorizationStatus(for: mediaType)
        switch status {
        case .authorized:
            complete(completion, value:true)
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: mediaType) { (authorized) in
                if authorized {
                    complete(completion, value:true)
                } else {
                    showDeniedAlert()
                }
            }
        case .restricted:
            complete(completion, value:false)
        case .denied:
            showDeniedAlert()
        default:
            break
        }
    }

    private static func showSettingsAlert(title: String?, message: String?, completion: PhotoLibraryRequestCompletion?, viewController: UIViewController?) {
        DispatchQueue.main.async {
            let alert = UIAlertController.init(title: title, message: message, preferredStyle: .appropriate)
            alert.addAction(UIAlertAction.init(title: Strings.settings, style: .default, handler: { (action) in
                complete(completion, value:false)
                openSettings()
            }))
            
            alert.addAction(UIAlertAction.init(title: Strings.cancel, style: .cancel, handler: { (action) in
                complete(completion, value:false)
            }))
            viewController?.present(alert, animated: true, completion: nil)
        }
    }

    private static func complete(_ completion: PhotoLibraryRequestCompletion?, value: Bool) {
        DispatchQueue.main.async {
            completion?(value)
        }
    }
    
    private static func openSettings() {
        if let url = URL.init(string: UIApplication.openSettingsURLString) {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
}
protocol ImagePickerDelegate: AnyObject {
    func didSelect(image: UIImage?, name: ImagePicker.Name)
}

open class ImagePicker: NSObject {
    
    struct Name {
        var fileName: String
        var extn: String
        
        var fullName: String {
            return [fileName, extn].joined(separator: ".")
        }
        
        static var `default`: Name {
            return Name(fileName: "Image", extn: "jpg")
        }
    }

    private let pickerController: UIImagePickerController
    weak var presentationController: UIViewController?
    private weak var delegate: ImagePickerDelegate?
    
    private var name: ImagePicker.Name = .default

    init(presentationController: UIViewController?, delegate: ImagePickerDelegate?) {
        self.pickerController = UIImagePickerController()
        super.init()

        self.presentationController = presentationController
        self.delegate = delegate

        self.pickerController.mediaTypes = ["public.image"]
    }

    private func action(for type: UIImagePickerController.SourceType, title: String) -> UIAlertAction? {
        guard UIImagePickerController.isSourceTypeAvailable(type) else {
            return nil
        }

        return UIAlertAction(title: title, style: .default) { [unowned self] _ in
            
            func open() {
                self.pickerController.delegate = self
                self.pickerController.sourceType = type
                self.presentationController?.present(self.pickerController, animated: true)
            }
            
            switch type {
            case .camera:
                RequestAccessHandler.canOpenCamera(for: .video, { (success) in
                    if success {
                        open()
                    }
                }, for: self.presentationController)
            case .photoLibrary, .savedPhotosAlbum:
                RequestAccessHandler.canOpenPhotos({ (success) in
                    if success {
                        open()
                    }
                }, for: self.presentationController)
            default:
                open()
            }
        }
    }

    public func present(from sourceView: UIView? = nil, barButton: UIBarButtonItem? = nil) {
        
        var preferredStyle: UIAlertController.Style = .actionSheet
        
        if sourceView == nil && barButton == nil {
            preferredStyle = .appropriate
        }

        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: preferredStyle)

        alertActions().forEach { (action) in
            alertController.addAction(action)
        }
        alertController.addAction(UIAlertAction(title: Strings.cancel, style: .cancel, handler: nil))

        if let sourceView = sourceView {
            alertController.modalPresentationStyle = .popover
            alertController.popoverPresentationController?.sourceView = sourceView
            alertController.popoverPresentationController?.sourceRect = sourceView.bounds
            alertController.popoverPresentationController?.permittedArrowDirections = [.down, .up]
        } else if let barButton = barButton {
            alertController.modalPresentationStyle = .popover
            alertController.popoverPresentationController?.barButtonItem = barButton
            alertController.popoverPresentationController?.permittedArrowDirections = [.down, .up]
        }
        
        self.presentationController?.present(alertController, animated: true)
    }
    
    func alertActions() -> [UIAlertAction] {
        return imagePickertAlertActions
    }
    
    var imagePickertAlertActions: [UIAlertAction] {
        var actions = [UIAlertAction]()
        if let camera = self.action(for: .camera, title: Strings.camera) {
            actions.append(camera)
        }
        if let photoLibrary = self.action(for: .photoLibrary, title: Strings.photoLibrary) {
            actions.append(photoLibrary)
        }
        return actions
    }

    func pickerController(_ controller: UIImagePickerController, didSelect image: UIImage?) {
//        guard let image = image else {
//            controller.dismiss(animated: true, completion: nil)
//            return
//        }
//
//        let cropViewController = CropViewController.init(image: image)
//        cropViewController.delegate = self
//        controller.dismiss(animated: true) {
//            self.presentationController?.present(cropViewController, animated: true, completion: nil)
//        }
    }
    
    private func update(croppedImage: UIImage?) {
        self.delegate?.didSelect(image: croppedImage, name: name)
        self.name = .default
    }
}

//extension ImagePicker: CropViewControllerDelegate {
//    public func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
//        cropViewController.dismiss(animated: true) {
//            self.update(croppedImage: image)
//        }
//
//    }
//}

extension ImagePicker: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.pickerController(picker, didSelect: nil)
    }

    public func imagePickerController(_ picker: UIImagePickerController,
                                      didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        self.pickerController.delegate = nil
        self.updateImageName(info)
        
        if let image = info[.editedImage] as? UIImage {
            self.pickerController(picker, didSelect: image)
        } else if let image = info[.originalImage] as? UIImage {
            self.pickerController(picker, didSelect: image)
        } else {
            self.pickerController(picker, didSelect: nil)
        }
    }
    
    private func updateImageName(_ info: [UIImagePickerController.InfoKey: Any]) {
        var fileName = "Image"
        let ext = "jpeg"
        
        if let phAsset = info[UIImagePickerController.InfoKey.phAsset] as? PHAsset, let originalFilename = PHAssetResource.assetResources(for: phAsset).first?.originalFilename {

            let comps = originalFilename.components(separatedBy: ".")
            
            if let extns = comps.last {
//                    ext = extns
                fileName = originalFilename.replacingOccurrences(of: ".\(extns)", with: "")
            } else {
                fileName = originalFilename
            }
        }
        
        self.name = Name(fileName: fileName, extn: ext)
    }
}
