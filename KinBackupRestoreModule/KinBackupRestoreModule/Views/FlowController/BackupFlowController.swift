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
        viewController.continueButton.addTarget(self, action: #selector(push), for: .touchUpInside)
        return viewController
    }()
    
    override var entryViewController: UIViewController {
        return _entryViewController
    }
}

extension BackupFlowController: LifeCycleProtocol {
    func viewController(_ viewController: UIViewController, willAppear animated: Bool) {
        
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

    // !!!: DEBUG
    @objc
    func push() {
        let str = "{\"pkey\":\"GB2FKV3UT7HC4QCCRKZWNAYLTADH32HTUL3QMWA2IX44LUGVVH7CYENZ\",\"seed\":\"c123df51eaae55d05e4c01d6642cab1c300101e2396d2ec0f1523887eca078362abe4e32d2d2cada278375e85a294b5b1cdb104b505205a0932908a686c8c6915d14ebfb922ceb95\",\"salt\":\"d3ab5f31e46b446ad753a2130fd52173\"}"
        pushQRViewController(with: str)
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
