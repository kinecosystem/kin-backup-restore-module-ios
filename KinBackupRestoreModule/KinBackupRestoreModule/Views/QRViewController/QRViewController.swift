//
//  QRViewController.swift
//  KinEcosystem
//
//  Created by Corey Werner on 18/10/2018.
//  Copyright © 2018 Kik Interactive. All rights reserved.
//

import UIKit
import MessageUI

protocol QRViewControllerDelegate: NSObjectProtocol {
    func QRViewControllerDidComplete(_ viewController: QRViewController)
}

class QRViewController: ViewController {
    weak var delegate: QRViewControllerDelegate!

    private let qrImage: UIImage?
    private var mailViewController: MFMailComposeViewController?

    // MARK: View

    var imageView: UIImageView {
        return _view.imageView
    }

    private var confirmControl: UIControl {
        return _view.confirmControl
    }

    private var doneButton: RoundButton {
        return _view.doneButton
    }

    private var isConfirmed: Bool {
        return _view.isConfirmed
    }

    var _view: QRView {
        return view as! QRView
    }

    var classForView: QRView.Type {
        return QRView.self
    }

    override func loadView() {
        view = classForView.self.init(frame: .zero)
    }

    // MARK: Lifecycle

    init(qrString: String) {
        self.qrImage = QRController.generateImage(from: qrString)

        super.init(nibName: nil, bundle: nil)

        title = "qr.title".localized()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        KinBackupRestoreBI.shared.delegate?.kinBackupQrCodePageViewed()

        imageView.image = qrImage

//        confirmControl.isHidden = true
        confirmControl.addTarget(self, action: #selector(confirmAction), for: .touchUpInside)

        doneButton.addTarget(self, action: #selector(doneAction), for: .touchUpInside)
    }

    override func willMove(toParent parent: UIViewController?) {
        super.willMove(toParent: parent)

        if parent == nil {
            KinBackupRestoreBI.shared.delegate?.kinBackupQrCodeBackButtonTapped()
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidTakeScreenshot), name: UIApplication.userDidTakeScreenshotNotification, object: nil)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc
    private func applicationDidTakeScreenshot() {
        if isViewLoaded && view.window != nil {
            confirmControl.isHidden = false
        }
    }

    // MARK: Actions

    @objc
    private func doneAction() {
        if isConfirmed {
            delegate.QRViewControllerDidComplete(self)
        }
        else {
            presentMailViewController()
        }
    }
    
    @objc
    private func confirmAction() {
        KinBackupRestoreBI.shared.delegate?.kinBackupQrCodeMyqrcodeButtonTapped()

        doneButton.isSelected = isConfirmed
    }
}

// MARK: - Mail

extension QRViewController {
    fileprivate enum MailError: Error {
        case noClient
        case critical
    }
}

extension QRViewController.MailError {
    var title: String {
        switch self {
        case .noClient:
            return "qr.alert_no_client.title".localized()
        case .critical:
            return "qr.alert_critical.title".localized()
        }
    }

    var message: String {
        switch self {
        case .noClient:
            return "qr.alert_no_client.message".localized()
        case .critical:
            return "qr.alert_critical.message".localized()
        }
    }
}

extension QRViewController {
    fileprivate func presentMailViewController() {
        KinBackupRestoreBI.shared.delegate?.kinBackupQrCodeSendButtonTapped()

        guard MFMailComposeViewController.canSendMail() else {
            presentMailErrorAlertController(.noClient)
            return
        }
        
        guard let data = qrImage?.pngData() else {
            presentMailErrorAlertController(.critical)
            return
        }
        
        let mailViewController = MFMailComposeViewController()
        mailViewController.mailComposeDelegate = self
        mailViewController.setSubject("qr.email.subject".localized())
        mailViewController.addAttachmentData(data, mimeType: "image/png", fileName: "qr.png")
        present(mailViewController, animated: true)
        self.mailViewController = mailViewController
    }
    
    private func presentMailErrorAlertController(_ error: MailError) {
        let alertController = UIAlertController(title: error.title, message: error.message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "generic.ok".localized(), style: .cancel))
        present(alertController, animated: true)
    }
}

extension QRViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        dismiss(animated: true) { [weak self] in
            self?.confirmControl.isHidden = false
        }
        mailViewController = nil
    }
}
