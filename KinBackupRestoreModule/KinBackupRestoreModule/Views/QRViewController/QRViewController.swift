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
    func QRViewControllerDidComplete()
}

class QRViewController: ViewController {
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var qrImageView: UIImageView!
    @IBOutlet weak var reminderImageView: UIImageView!
    @IBOutlet weak var reminderTitleLabel: UILabel!
    @IBOutlet weak var reminderDescriptionLabel: UILabel!
    @IBOutlet weak var emailButton: RoundButton!
    @IBOutlet weak var copiedQRLabel: UILabel!
    @IBOutlet weak var tickImage: UIImageView!
    @IBOutlet weak var tickStack: UIStackView!
    @IBOutlet weak var confirmTick: UIView!
    @IBOutlet weak var topSpace: NSLayoutConstraint!
    
    private let qrString: String
    private var mailViewController: MFMailComposeViewController?
    private(set) var tickMarked = false
    
    weak var delegate: QRViewControllerDelegate!

    // MARK: View

    var imageView: UIImageView {
        return _view.imageView
    }

    private var instructionsLabel: UILabel {
        return _view.instructionsLabel
    }

    private var reminderLabel: UILabel {
        return _view.reminderLabel
    }

    private var doneButton: RoundButton {
        return _view.doneButton
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
        self.qrString = qrString

        super.init(nibName: nil, bundle: nil)
//        super.init(nibName: "QRViewController", bundle: .backupRestore)
//        loadViewIfNeeded()

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

        instructionsLabel.text = "qr.description".localized()

        imageView.image = QRController.generateImage(from: qrString)

//        reminderImageView.tintColor = .kinWarning
//        reminderImageView.tintAdjustmentMode = .normal

        doneButton.setTitle("qr.save".localized(), for: .normal)
        doneButton.addTarget(self, action: #selector(emailButtonTapped), for: .touchUpInside)

//        copiedQRLabel.text = "qr.saved".localized()
//        copiedQRLabel.font = .preferredFont(forTextStyle: .body)
//        copiedQRLabel.textColor = .kinBlueGreyTwo
//
//        confirmTick.layer.borderWidth = 1.0
//        confirmTick.layer.borderColor = UIColor.kinBlueGreyTwo.cgColor
//        confirmTick.layer.cornerRadius = 2.0
//
//        tickStack.isHidden = true
//        tickImage.isHidden = true

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
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc
    private func applicationDidTakeScreenshot() {
        if isViewLoaded && view.window != nil {
            tickStack.isHidden = false
        }
    }
    
    @IBAction
    func tickSelected(_ sender: Any) {
        KinBackupRestoreBI.shared.delegate?.kinBackupQrCodeMyqrcodeButtonTapped()

        tickMarked = !tickMarked
        tickImage.isHidden = !tickMarked
        doneButton.setTitle((tickMarked ? "generic.next" : "qr.save").localized(), for: .normal)
    }
}

// MARK: - Email

extension QRViewController {
    private enum EmailError: Error {
        case noClient
        case critical
        
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
    
    @objc
    private func emailButtonTapped() {
        guard tickMarked == false else {
            delegate.QRViewControllerDidComplete()
            return
        }
        
        KinBackupRestoreBI.shared.delegate?.kinBackupQrCodeSendButtonTapped()

        guard MFMailComposeViewController.canSendMail() else {
            presentEmailErrorAlertController(.noClient)
            return
        }
        
        guard let qrImage = QRController.generateImage(from: qrString), let data = qrImage.pngData() else {
            presentEmailErrorAlertController(.critical)
            return
        }
        
        let mailViewController = MFMailComposeViewController()
        mailViewController.mailComposeDelegate = self
        mailViewController.setSubject("qr.email.subject".localized())
        mailViewController.addAttachmentData(data, mimeType: "image/png", fileName: "qr.png")
        present(mailViewController, animated: true)
        self.mailViewController = mailViewController
    }
    
    private func presentEmailErrorAlertController(_ error: EmailError) {
        let alertController = UIAlertController(title: error.title, message: error.message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "generic.ok".localized(), style: .cancel))
        present(alertController, animated: true)
    }
}

extension QRViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        dismiss(animated: true) { [weak self] in
            self?.tickStack.isHidden = false
        }
        mailViewController = nil
    }
}
