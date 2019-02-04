//
//  QRPickerController.swift
//  KinEcosystem
//
//  Created by Corey Werner on 25/10/2018.
//  Copyright © 2018 Kik Interactive. All rights reserved.
//

import UIKit

protocol QRPickerControllerDelegate: NSObjectProtocol {
    func qrPickerControllerDidComplete(_ controller: QRPickerController, with qrString: String?)
}

class QRPickerController: NSObject {
    weak var delegate: QRPickerControllerDelegate?
    
    let imagePickerController = UIImagePickerController()
    
    static var canOpenImagePicker: Bool {
        return UIImagePickerController.isSourceTypeAvailable(.photoLibrary)
    }
    
    override init() {
        super.init()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
    }
}

extension QRPickerController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        delegate?.qrPickerControllerDidComplete(self, with: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            
            DispatchQueue.global().async {
                let qrString = QR.decode(image: image)
                if let qr = qrString {
                    DispatchQueue.main.async {
                        self.delegate?.qrPickerControllerDidComplete(self, with: qr)
                    }
                } else {
                    DispatchQueue.main.async {
                        self.presentImageError()
                    }
                }
                
            }
            
        } else {
            DispatchQueue.main.async {
                self.presentImageError()
            }
        }
        
    }
    
    func presentImageError() {
        let title = "QR not recognized".localized()
        let message = "A QR code could not be detected in the image.".localized()
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "kinecosystem_ok".localized(), style: .cancel))
        self.imagePickerController.present(alertController, animated: true)
    }
    
}

// TODO: move

extension String {
    func localized(_ args: CVarArg...) -> String {
        return String(format: NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: ""), arguments: args)
    }

    func attributed(_ size: CGFloat, weight: UIFont.Weight, color: UIColor) -> NSAttributedString {
        return NSAttributedString(string: self,
                                  attributes: [.font : UIFont.systemFont(ofSize: size, weight: weight),
                                               .foregroundColor : color])
    }
    
}
