//
//  FilePicker.swift
//  BoilerPlate
//
//  Created by dhanasekaran on 18/08/21.
//

import UIKit
import MobileCoreServices
import UniformTypeIdentifiers

protocol FilePickerDelegate: AnyObject
{
    func didSelect(fileURL: URL)
}

open class FilePicker: ImagePicker
{
    private let documentPickerController: UIDocumentPickerViewController
    private weak var filePickerDelegate: FilePickerDelegate?
    
    init(presentationController: UIViewController?, delegate: FilePickerDelegate) {
        self.documentPickerController = UIDocumentPickerViewController.init(documentTypes: ["public.data"], in: .import)
        
        super.init(presentationController: presentationController, delegate: nil)
        self.filePickerDelegate = delegate
        self.documentPickerController.delegate = self
    }
    
    override func alertActions() -> [UIAlertAction] {
        let fileUploadAction = UIAlertAction.init(title: Strings.browse, style: .default) { (_) in
            self.presentationController?.present(self.documentPickerController, animated: true, completion: nil)
        }
        var defaultActions = imagePickertAlertActions
        defaultActions.append(fileUploadAction)
        return defaultActions
    }
}
extension FilePicker: UIDocumentPickerDelegate
{
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let myURL = urls.first else {
            return
        }
        print("import result : \(myURL)")
        filePickerDelegate?.didSelect(fileURL: myURL)
    }

    public func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("view was cancelled")
        documentPickerController.dismiss(animated: true, completion: nil)
    }
    
    public override func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let imageURL = info[UIImagePickerController.InfoKey.imageURL] as? URL else {
            picker.dismiss(animated: true, completion: nil)
            return
        }
        print("import result : \(imageURL)")
        picker.dismiss(animated: true) {
            self.filePickerDelegate?.didSelect(fileURL: imageURL)
        }
    }
}

