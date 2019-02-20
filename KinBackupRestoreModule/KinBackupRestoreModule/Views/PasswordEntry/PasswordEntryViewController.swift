//
//  PasswordEntryViewController.swift
//  KinEcosystem
//
//  Created by Elazar Yifrach on 16/10/2018.
//  Copyright © 2018 Kik Interactive. All rights reserved.
//

import UIKit

protocol PasswordEntryViewControllerDelegate: NSObjectProtocol {
    func passwordEntryViewController(_ viewController: PasswordEntryViewController, validate password: String) -> Bool
    func passwordEntryViewControllerDidComplete(_ viewController: PasswordEntryViewController, with password: String)
}

class PasswordEntryViewController: ViewController {
    weak var delegate: PasswordEntryViewControllerDelegate?

    // MARK: View

    private var passwordInfo: PasswordEntryLabel {
        return _view.passwordInfo
    }
    private var passwordInput1: PasswordEntryTextField {
        return _view.passwordInput1
    }
    private var passwordInput2: PasswordEntryTextField {
        return _view.passwordInput2
    }
    private var confirmLabel: UILabel {
        return _view.confirmLabel
    }
    private var doneButton: RoundButton {
        return _view.doneButton
    }

    private lazy var _view: PasswordEntryView = {
        return PasswordEntryView()
    }()

    override func loadView() {
        view = _view
    }

    // MARK: Lifecycle

    init() {
        super.init(nibName: nil, bundle: nil)
//        super.init(nibName: "PasswordEntryViewController", bundle: .backupRestore)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidChangeFrameNotification(_:)), name: UIResponder.keyboardDidChangeFrameNotification, object: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        KinBackupRestoreBI.shared.delegate?.kinBackupCreatePasswordPageViewed()

        passwordInfo.instructionsAttributedString = NSAttributedString(string: "kinecosystem_password_instructions".localized(), attributes: [.foregroundColor: UIColor.kinBlueGreyTwo])
        passwordInfo.mismatchAttributedString = NSAttributedString(string: "kinecosystem_password_mismatch".localized(), attributes: [.foregroundColor: UIColor.kinWarning])
        passwordInfo.invalidAttributedString = {
            let attributedString1 = NSAttributedString(string: "kinecosystem_password_invalid_warning".localized(), attributes: [.foregroundColor: UIColor.kinWarning])

            let attributedString2 = NSAttributedString(string: "kinecosystem_password_invalid_info".localized(), attributes: [.foregroundColor: UIColor.kinBlueGreyTwo])

            let attributedString = NSMutableAttributedString()
            attributedString.append(attributedString1)
            attributedString.append(attributedString2)
            return attributedString
        }()

        passwordInput1.attributedPlaceholder = NSAttributedString(string: "kinecosystem_password".localized(), attributes: [.foregroundColor: UIColor.kinBlueGreyTwo])
        passwordInput1.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        passwordInput1.becomeFirstResponder()

        passwordInput2.attributedPlaceholder = NSAttributedString(string: "kinecosystem_confirm_password".localized(), attributes: [.foregroundColor: UIColor.kinBlueGreyTwo])
        passwordInput2.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)

        confirmLabel.text = "kinecosystem_password_confirmation".localized()

        doneButton.setTitle("kinecosystem_next".localized(), for: .normal)
        doneButton.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
    }

    @objc
    private func keyboardDidChangeFrameNotification(_ notification: Notification) {
        guard let frame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
            return
        }

        _view.bottomLayoutGuideHeight.constant = frame.height
    }

    override func willMove(toParent parent: UIViewController?) {
        super.willMove(toParent: parent)

        if parent == nil {
            // ???: this seems wrong
            KinBackupRestoreBI.shared.delegate?.kinBackupCreatePasswordBackButtonTapped()
        }
    }

    // MARK: Text Field
    
    @IBAction
    func textFieldDidChange(_ textField: UITextField) {
        if passwordInput1.hasText,
            let delegate = delegate,
            let password = passwordInput1.text,
            delegate.passwordEntryViewController(self, validate: password)
        {
            passwordInput1.entryState = .valid

            if passwordInput2.text == password {
                passwordInput2.entryState = .valid
            }
            else {
                passwordInput2.entryState = .default
            }
        }
        else {
            passwordInput1.entryState = .default
        }

        passwordInfo.state = .instructions
    }

    // MARK: Done Button
    
    @IBAction
    func doneButtonTapped(_ button: UIButton) {
        KinBackupRestoreBI.shared.delegate?.kinBackupCreatePasswordNextButtonTapped()

        guard let password = passwordInput1.text, passwordInput1.hasText && passwordInput2.hasText else {
            return // shouldn't really happen, here for documenting
        }

        guard passwordInput1.text == passwordInput2.text else {
            alertPasswordsDontMatch()
            return
        }

        guard let delegate = delegate else {
            return
        }
        
        guard delegate.passwordEntryViewController(self, validate: password) else {
            alertPasswordsConformance()
            return
        }

        delegate.passwordEntryViewControllerDidComplete(self, with: password)
    }

    func alertPasswordsDontMatch() {
        passwordInfo.state = .mismatch
        passwordInput2.text = ""
        passwordInput1.becomeFirstResponder()
    }
    
    func alertPasswordsConformance() {
        passwordInfo.state = .invalid
    }
}

extension PasswordEntryViewController {
    func presentErrorAlert() {
        // TODO: update copy
        let alertController = UIAlertController(title: "That's strange", message: "An error occurred. Please try again.", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .cancel))
        present(alertController, animated: true)
    }
}
