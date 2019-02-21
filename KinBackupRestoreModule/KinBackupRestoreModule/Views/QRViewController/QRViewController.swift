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
    
    init(qrString: String) {
        self.qrString = qrString
        super.init(nibName: "QRViewController", bundle: .backupRestore)
        loadViewIfNeeded()

        title = "qr.title".localized()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func willMove(toParent parent: UIViewController?) {
        super.willMove(toParent: parent)

        if parent == nil {
            KinBackupRestoreBI.shared.delegate?.kinBackupQrCodeBackButtonTapped()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        KinBackupRestoreBI.shared.delegate?.kinBackupQrCodePageViewed()

        descriptionLabel.text = "qr.description".localized()
        descriptionLabel.font = .preferredFont(forTextStyle: .body)
        descriptionLabel.textColor = .kinBlueGreyTwo

        qrImageView.image = QRController.generateImage(from: qrString, for: qrImageView.bounds.size)

        reminderImageView.tintColor = .kinWarning
        reminderImageView.tintAdjustmentMode = .normal

        reminderTitleLabel.text = "reminder.title".localized()
        reminderTitleLabel.font = .preferredFont(forTextStyle: .callout, symbolicTraits: [.traitBold])
        reminderTitleLabel.textColor = .kinWarning

        reminderDescriptionLabel.text = "reminder.description".localized()
        reminderDescriptionLabel.font = .preferredFont(forTextStyle: .footnote)
        reminderDescriptionLabel.textColor = .kinWarning

        emailButton.setTitle("qr.save".localized(), for: .normal)
        emailButton.setTitleColor(.white, for: .normal)
        emailButton.backgroundColor = .kinPrimaryBlue
        emailButton.addTarget(self, action: #selector(emailButtonTapped), for: .touchUpInside)

        copiedQRLabel.text = "qr.saved".localized()
        copiedQRLabel.font = .preferredFont(forTextStyle: .body)
        copiedQRLabel.textColor = .kinBlueGreyTwo

        confirmTick.layer.borderWidth = 1.0
        confirmTick.layer.borderColor = UIColor.kinBlueGreyTwo.cgColor
        confirmTick.layer.cornerRadius = 2.0

        tickStack.isHidden = true
        tickImage.isHidden = true
        
        if #available(iOS 11, *) {
            // ???: why
            topSpace.constant = 0.0
            view.layoutIfNeeded()
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
        emailButton.setTitle((tickMarked ? "generic.next" : "qr.save").localized(), for: .normal)
    }
}

// MARK: - Email

extension QRViewController {
    private enum EmailError: Error {
        case noClient
        case critical
        
        var title: String {
            // TODO: get correct copy
            switch self {
            case .noClient:
                return "No email client"
            case .critical:
                return "Something went wrong"
            }
        }
        
        var message: String {
            // TODO: get correct copy
            switch self {
            case .noClient:
                return "You need to set up an email client first in the settings app."
            case .critical:
                return "Try again."
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
            presentEmailErrorAlert(.noClient)
            return
        }
        
        guard let qrImage = QRController.generateImage(from: qrString), let data = qrImage.pngData() else {
            presentEmailErrorAlert(.critical)
            return
        }
        
        let mailViewController = MFMailComposeViewController()
        mailViewController.mailComposeDelegate = self
        mailViewController.setSubject("Kin Backup QR Code") // TODO: get correct copy
        mailViewController.addAttachmentData(data, mimeType: "image/png", fileName: "qr.png")
        present(mailViewController, animated: true)
        self.mailViewController = mailViewController
    }
    
    private func presentEmailErrorAlert(_ error: EmailError) {
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
