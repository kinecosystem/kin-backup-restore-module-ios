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
    @IBOutlet weak var passwordInfo: PasswordEntryLabel!
    @IBOutlet weak var passwordInput1: PasswordEntryField!
    @IBOutlet weak var passwordInput2: PasswordEntryField!
    @IBOutlet weak var confirmLabel: UILabel!
    @IBOutlet weak var confirmTick: UIView!
    @IBOutlet weak var doneButton: RoundButton!
    @IBOutlet weak var bottomSpace: NSLayoutConstraint!
    @IBOutlet weak var tickStack: UIStackView!
    @IBOutlet weak var tickImage: UIImageView!
    @IBOutlet weak var topSpace: NSLayoutConstraint!
    
    weak var delegate: PasswordEntryViewControllerDelegate?
    
    private var kbObservers = [NSObjectProtocol]()
    private var tickMarked = false

    init() {
        super.init(nibName: "PasswordEntryViewController", bundle: .backupRestore)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        loadViewIfNeeded()
    }

    deinit {
        kbObservers.forEach { obs in
            NotificationCenter.default.removeObserver(obs)
        }
        kbObservers.removeAll()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        KinBackupRestoreBI.shared.delegate?.kinBackupCreatePasswordPageViewed()

        passwordInfo.font = .preferredFont(forTextStyle: .body)
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
        passwordInput1.becomeFirstResponder()

        passwordInput2.attributedPlaceholder = NSAttributedString(string: "kinecosystem_confirm_password".localized(), attributes: [.foregroundColor: UIColor.kinBlueGreyTwo])

        confirmLabel.text = "kinecosystem_password_confirmation".localized()
        confirmLabel.font = .preferredFont(forTextStyle: .footnote)
        confirmLabel.textColor = .kinBlueGreyTwo

        confirmTick.layer.borderWidth = 1
        confirmTick.layer.borderColor = UIColor.kinBlueGreyTwo.cgColor
        confirmTick.layer.cornerRadius = 2

        tickImage.isHidden = true

        doneButton.setTitleColor(.white, for: .normal)
        doneButton.isEnabled = false

        kbObservers.append(NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: nil) { [weak self] note in
            if let height = (note.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size.height,
                let duration = note.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double {
                DispatchQueue.main.async {
//                    self?.bottomSpace.constant = height
                    UIView.animate(withDuration: duration) {
                        self?.view.layoutIfNeeded()
                    }
                }
            }
        })
        
        kbObservers.append(NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: nil) { [weak self] note in
            if let duration = note.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double {
                DispatchQueue.main.async {
//                    self?.bottomSpace.constant = 0.0
                    UIView.animate(withDuration: duration) {
                        self?.view.layoutIfNeeded()
                    }
                }
            }
        })

        if #available(iOS 11, *) {
            // ???: why
//            topSpace.constant = 0.0
            view.layoutIfNeeded()
        }
    }

    override func willMove(toParent parent: UIViewController?) {
        super.willMove(toParent: parent)

        if parent == nil {
            // ???: this seems wrong
            KinBackupRestoreBI.shared.delegate?.kinBackupCreatePasswordBackButtonTapped()
        }
    }
    
    @IBAction
    func passwordEntryChanged(_ sender: UITextField) {
        updateDoneButton()

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
                passwordInput2.entryState = .idle
            }
        }
        else {
            passwordInput1.entryState = .idle
        }

        passwordInfo.state = .instructions
    }
    
    @IBAction
    func doneButtonTapped(_ sender: Any) {
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
    
    @IBAction
    func tickSelected(_ sender: Any) {
        tickMarked = !tickMarked
        tickImage.isHidden = !tickMarked
        updateDoneButton()
    }
    
    func alertPasswordsDontMatch() {
        passwordInfo.state = .mismatch
        passwordInput2.text = ""
        passwordInput1.becomeFirstResponder()
    }
    
    func alertPasswordsConformance() {
        passwordInfo.state = .invalid
    }
    
    func updateDoneButton() {
        doneButton.isEnabled = passwordInput1.hasText && passwordInput2.hasText && tickMarked
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
