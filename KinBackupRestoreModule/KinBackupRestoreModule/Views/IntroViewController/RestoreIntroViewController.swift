//
//  RestoreIntroViewController.swift
//  KinEcosystem
//
//  Created by Corey Werner on 25/10/2018.
//  Copyright © 2018 Kik Interactive. All rights reserved.
//

import UIKit

protocol RestoreIntroViewControllerDelegate: NSObjectProtocol {
    func restoreIntroViewControllerDidComplete(_ viewController: RestoreIntroViewController)
}

class RestoreIntroViewController: ExplanationTemplateViewController {
    weak var delegate: RestoreIntroViewControllerDelegate?
    private var canContinue = false

    override init() {
        super.init()

        title = "restore_intro.title".localized()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        KinBackupRestoreBI.shared.delegate?.kinRestoreUploadQrCodePageViewed()

        view.backgroundColor = .kinPrimary

        imageView.image = UIImage(named: "whiteQrCode", in: .backupRestore, compatibleWith: nil)

        titleLabel.text = "restore_intro.header".localized()

        descriptionLabel.text = "restore_intro.description".localized()

        doneButton.setTitle("restore_intro.next".localized(), for: .normal)
        doneButton.addTarget(self, action: #selector(continueAction), for: .touchUpInside)
    }
    
    override func willMove(toParent parent: UIViewController?) {
        super.willMove(toParent: parent)

        if parent == nil {
            KinBackupRestoreBI.shared.delegate?.kinRestoreUploadQrCodeBackButtonTapped()
        }
    }
    
    @objc
    private func continueAction() {
        KinBackupRestoreBI.shared.delegate?.kinRestoreUploadQrCodeButtonTapped()

        if canContinue {
            delegate?.restoreIntroViewControllerDidComplete(self)
        }
        else {
            presentAlertController()
        }
    }
    
    @objc
    private func presentAlertController() {
        let title = "restore_intro.alert.title".localized()
        let message = "restore_intro.alert.message".localized()
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let continueAction = UIAlertAction(title: "generic.ok".localized(), style: .default) { _ in
            KinBackupRestoreBI.shared.delegate?.kinRestoreAreYouSureOkButtonTapped()

            self.canContinue = true
            self.delegate?.restoreIntroViewControllerDidComplete(self)
        }
        alertController.addAction(UIAlertAction(title: "generic.cancel".localized(), style: .cancel) { _ in
            KinBackupRestoreBI.shared.delegate?.kinRestoreAreYouSureCancelButtonTapped()
        })
        alertController.addAction(continueAction)
        alertController.preferredAction = continueAction
        present(alertController, animated: true)
    }
}

