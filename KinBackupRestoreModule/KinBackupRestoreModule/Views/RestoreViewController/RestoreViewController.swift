//
//  RestoreViewController.swift
//  KinEcosystem
//
//  Created by Elazar Yifrach on 29/10/2018.
//  Copyright © 2018 Kik Interactive. All rights reserved.
//

import UIKit

protocol RestoreViewControllerDelegate: NSObjectProtocol {
    func restoreViewController(_ viewController: RestoreViewController, importWith password: String) -> RestoreViewController.ImportResult
    func restoreViewControllerDidComplete(_ viewController: RestoreViewController)
}

class RestoreViewController: ViewController {
    weak var delegate: RestoreViewControllerDelegate?
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var instructionsLabel: UILabel!
    @IBOutlet weak var passwordInput: PasswordEntryField!
    @IBOutlet weak var doneButton: RoundButton!
    @IBOutlet weak var bottomSpace: NSLayoutConstraint!
    @IBOutlet weak var topSpace: NSLayoutConstraint!
    
    private let passwordInstructions = "kinecosystem_restore_instructions".localized().attributed(12.0, weight: .regular, color: UIColor.kinBlueGreyTwo)
    private let passwordPlaceholder = "kinecosystem_enter_password".localized().attributed(12.0, weight: .regular, color: UIColor.kinBlueGreyTwo)
    private var kbObservers = [NSObjectProtocol]()
    
    init() {
        super.init(nibName: "RestoreViewController", bundle: .backupRestore)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        loadViewIfNeeded()
        title = "Restore Previous Wallet".localized() // TODO: 
    }

    deinit {
        kbObservers.forEach { obs in
            NotificationCenter.default.removeObserver(obs)
        }
        kbObservers.removeAll()
    }
    
    override func willMove(toParent parent: UIViewController?) {
        super.willMove(toParent: parent)

        if parent == nil {
            KinBackupRestoreBI.shared.delegate?.kinRestorePasswordEntryBackButtonTapped()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        KinBackupRestoreBI.shared.delegate?.kinRestorePasswordEntryPageViewed()

        passwordInput.attributedPlaceholder = passwordPlaceholder
        passwordInput.isSecureTextEntry = true
        instructionsLabel.attributedText = passwordInstructions
        doneButton.setTitleColor(.white, for: .normal)
        doneButton.isEnabled = false

        kbObservers.append(NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: nil) { [weak self] note in
            if let height = (note.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size.height,
                let duration = note.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double {
                DispatchQueue.main.async {
                    self?.bottomSpace.constant = height
                    UIView.animate(withDuration: duration) {
                        self?.view.layoutIfNeeded()
                    }
                }
            }
        })
        
        kbObservers.append(NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: nil) { [weak self] note in
            if let duration = note.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double {
                DispatchQueue.main.async {
                    self?.bottomSpace.constant = 0.0
                    UIView.animate(withDuration: duration) {
                        self?.view.layoutIfNeeded()
                    }
                }
            }
        })

        if #available(iOS 11, *) {
            topSpace.constant = 0.0
            view.layoutIfNeeded()
        }

        passwordInput.becomeFirstResponder()
    }
    
    @IBAction
    func passwordInputChanges(_ textField: PasswordEntryField) {
        doneButton.isEnabled = textField.hasText
    }
    
    @IBAction
    func doneButtonTapped(_ button: RoundButton) {
        guard !navigationItem.hidesBackButton else {
            // Button in mid transition
            return
        }

        KinBackupRestoreBI.shared.delegate?.kinRestorePasswordDoneButtonTapped()

        guard let delegate = delegate else {
            return
        }
        
        button.isEnabled = false
        navigationItem.hidesBackButton = true
        
        let importResult = delegate.restoreViewController(self, importWith: passwordInput.text ?? "")

        if importResult == .success {
            button.transitionToConfirmed { () -> () in
                delegate.restoreViewControllerDidComplete(self)
            }
        }
        else {
            button.isEnabled = true
            navigationItem.hidesBackButton = false
            presentErrorAlertController(result: importResult)
        }
    }
}

// MARK: -

extension RestoreViewController {
    enum ImportResult {
        case success
        case wrongPassword
        case invalidImage
        case internalIssue
    }
}

extension RestoreViewController.ImportResult {
    var errorDescription: String? {
        // TODO: get correct copy
        switch self {
        case .success:
            return nil
        case .wrongPassword:
            return "The password is not correct."
        case .invalidImage:
            return "The QR image could not be identified."
        case .internalIssue:
            return "Something went wrong. Try again."
        }
    }
}

// MARK: -

extension RestoreViewController {
    fileprivate func presentErrorAlertController(result: ImportResult) {
        // TODO: get correct copy

        let alertController = UIAlertController(title: "Try again", message: result.errorDescription, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "kinecosystem_ok".localized(), style: .cancel))
        present(alertController, animated: true)
    }
}
