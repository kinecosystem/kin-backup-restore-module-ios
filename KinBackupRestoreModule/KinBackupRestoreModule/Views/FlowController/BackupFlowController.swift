//
//  BackupFlowController.swift
//  KinEcosystem
//
//  Created by Corey Werner on 23/10/2018.
//  Copyright © 2018 Kik Interactive. All rights reserved.
//

import UIKit
import KinSDK

class BackupFlowController: FlowController {
    let kinAccount: KinAccount

    init(kinAccount: KinAccount, navigationController: UINavigationController) {
        self.kinAccount = kinAccount
        super.init(navigationController: navigationController)
    }

    private lazy var _entryViewController: UIViewController = {
        let viewController = BackupIntroViewController()
        viewController.lifeCycleDelegate = self
        viewController.continueButton.addTarget(self, action: #selector(pushPasswordViewController), for: .touchUpInside)
        return viewController
    }()
    
    override var entryViewController: UIViewController {
        return _entryViewController
    }
}

extension BackupFlowController: LifeCycleProtocol {
    func viewController(_ viewController: UIViewController, willAppear animated: Bool) {
        syncNavigationBarColor(with: viewController)
    }
    
    func viewController(_ viewController: UIViewController, willDisappear animated: Bool) {
        cancelFlowIfNeeded(viewController)
    }
}

// MARK: - Navigation

extension BackupFlowController {
    @objc
    private func pushPasswordViewController() {
        KinBackupRestoreBI.shared.delegate?.kinBackupStartButtonTapped()

        let viewController = PasswordEntryViewController()
        viewController.delegate = self
        viewController.lifeCycleDelegate = self
        navigationController.pushViewController(viewController, animated: true)
    }

    @objc
    private func pushQRViewController(with qrString: String) {
        let viewController = QRViewController(qrString: qrString)
        viewController.delegate = self
        viewController.lifeCycleDelegate = self
        navigationController.pushViewController(viewController, animated: true)
    }
    
    @objc
    private func pushCompletedViewController() {
        let viewController = BackupCompletedViewController()
        viewController.lifeCycleDelegate = self
        viewController.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(completedFlow))
        navigationController.pushViewController(viewController, animated: true)
    }
    
    @objc
    private func completedFlow() {
        delegate?.flowControllerDidComplete(self)
    }
}

// MARK: - Flow

extension BackupFlowController: PasswordEntryViewControllerDelegate {
    func passwordEntryViewController(_ viewController: PasswordEntryViewController, validate password: String) -> Bool {
        let digit = "(?=.*\\d)"
        let upper = "(?=.*[A-Z])"
        let lower = "(?=.*[a-z])"
        let special = "(?=.*[!@#$%^&*()_+{}\\[\\]])"
        let min = 9
        let pattern = "^\(digit)\(upper)\(lower)\(special)(.{\(min),})$"

        do {
            let regex = try NSRegularExpression(pattern: pattern, options: [])
            let results = regex.matches(in: password, range: NSRange(password.startIndex..., in: password))
            return !results.isEmpty
        }
        catch {
            return false
        }
    }

    func passwordEntryViewControllerDidComplete(_ viewController: PasswordEntryViewController, with password: String) {
        do {
            pushQRViewController(with: try kinAccount.export(passphrase: password))
        }
        catch {
            viewController.presentErrorAlertController()
        }
    }
}

extension BackupFlowController: QRViewControllerDelegate {
    func QRViewControllerDidComplete() {
        pushCompletedViewController()
    }
}
