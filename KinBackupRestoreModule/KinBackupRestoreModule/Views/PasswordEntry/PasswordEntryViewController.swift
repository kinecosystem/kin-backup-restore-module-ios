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

    private var passwordInfoLabel: PasswordEntryLabel {
        return _view.passwordInfoLabel
    }

    private var passwordTextField: PasswordEntryTextField {
        return _view.passwordTextField
    }

    private var passwordConfirmTextField: PasswordEntryTextField {
        return _view.passwordConfirmTextField
    }

    private var confirmLabel: UILabel {
        return _view.confirmLabel
    }

    private var doneButton: RoundButton {
        return _view.doneButton
    }

    var _view: PasswordEntryView {
        return view as! PasswordEntryView
    }

    var classForView: PasswordEntryView.Type {
        return PasswordEntryView.self
    }

    override func loadView() {
        view = classForView.self.init(frame: .zero)
    }

    // MARK: Lifecycle

    init() {
        super.init(nibName: nil, bundle: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrameNotification(_:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)

        title = "password_entry.title".localized()
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

        passwordInfoLabel.instructionsAttributedString = NSAttributedString(string: "password_entry.instructions".localized(), attributes: [.foregroundColor: UIColor.kinBlueGreyTwo])
        passwordInfoLabel.mismatchAttributedString = NSAttributedString(string: "password_entry.mismatch".localized(), attributes: [.foregroundColor: UIColor.kinWarning])
        passwordInfoLabel.invalidAttributedString = {
            let attributedString1 = NSAttributedString(string: "password_entry.invalid_warning".localized(), attributes: [.foregroundColor: UIColor.kinWarning])

            let attributedString2 = NSAttributedString(string: "password_entry.invalid_info".localized(), attributes: [.foregroundColor: UIColor.kinBlueGreyTwo])

            let attributedString = NSMutableAttributedString()
            attributedString.append(attributedString1)
            attributedString.append(NSAttributedString(string: "\n"))
            attributedString.append(attributedString2)
            return attributedString
        }()

        passwordTextField.attributedPlaceholder = NSAttributedString(string: "password_entry.password.placeholder".localized(), attributes: [.foregroundColor: UIColor.kinBlueGreyTwo])
        passwordTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        passwordTextField.becomeFirstResponder()

        passwordConfirmTextField.attributedPlaceholder = NSAttributedString(string: "password_entry.password_confirm.placeholder".localized(), attributes: [.foregroundColor: UIColor.kinBlueGreyTwo])
        passwordConfirmTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)

        confirmLabel.text = "password_entry.confirmation".localized()

        doneButton.setTitle("generic.next".localized(), for: .normal)
        doneButton.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
    }

    @objc
    private func keyboardWillChangeFrameNotification(_ notification: Notification) {
        let frame = notification.endFrame

        guard frame != .null else {
            return
        }

        // iPhone X keyboard has a height when it's not displayed.
        let bottomHeight = max(0, view.bounds.height - frame.origin.y - view.layoutMargins.bottom)

        _view.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: bottomHeight, right: 0)

        let isViewOnScreen = view.layer.presentation() != nil

        if isViewOnScreen {
            UIView.animate(withDuration: notification.duration, delay: 0, options: notification.animationOptions, animations: {
                self._view.bottomLayoutHeight = bottomHeight
                self._view.layoutIfNeeded()
            })
        }
        else {
            _view.bottomLayoutHeight = bottomHeight
        }
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
        if passwordTextField.hasText,
            let delegate = delegate,
            let password = passwordTextField.text,
            delegate.passwordEntryViewController(self, validate: password)
        {
            passwordTextField.entryState = .valid

            if passwordConfirmTextField.text == password {
                passwordConfirmTextField.entryState = .valid
            }
            else {
                passwordConfirmTextField.entryState = .default
            }
        }
        else {
            passwordTextField.entryState = .default
        }

        passwordInfoLabel.state = .instructions
    }

    // MARK: Done Button
    
    @IBAction
    func doneButtonTapped(_ button: UIButton) {
        KinBackupRestoreBI.shared.delegate?.kinBackupCreatePasswordNextButtonTapped()

        guard let password = passwordTextField.text, passwordTextField.hasText && passwordConfirmTextField.hasText else {
            return // shouldn't really happen, here for documenting
        }

        guard passwordTextField.text == passwordConfirmTextField.text else {
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
        passwordInfoLabel.state = .mismatch
        passwordConfirmTextField.text = ""
        passwordTextField.becomeFirstResponder()
    }
    
    func alertPasswordsConformance() {
        passwordInfoLabel.state = .invalid
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
