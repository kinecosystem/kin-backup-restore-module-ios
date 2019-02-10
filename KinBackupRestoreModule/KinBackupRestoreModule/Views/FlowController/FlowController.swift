//
//  FlowController.swift
//  KinEcosystem
//
//  Created by Corey Werner on 23/10/2018.
//  Copyright © 2018 Kik Interactive. All rights reserved.
//

import UIKit

protocol FlowControllerDelegate: NSObjectProtocol {
    func flowControllerDidComplete(_ controller: FlowController)
    func flowControllerDidCancel(_ controller: FlowController)
}

class FlowController: NSObject {
    weak var delegate: FlowControllerDelegate?
    
    let keystoreDelegate: KinBackupRestoreKeystoreDelegate
    let navigationController: UINavigationController
    
    init(keystoreDelegate: KinBackupRestoreKeystoreDelegate, navigationController: UINavigationController) {
        self.keystoreDelegate = keystoreDelegate
        self.navigationController = navigationController
        super.init()
    }
    
    var entryViewController: UIViewController {
        fatalError("entryViewController() has not been implemented")
    }
    
    func syncNavigationBarColor(with viewController: UIViewController) {
        navigationController.navigationBar.tintColor = viewController.preferredStatusBarStyle.color
    }
    
    @objc func cancelFlow() {
        delegate?.flowControllerDidCancel(self)
    }
    
    func cancelFlowIfNeeded(_ viewController: UIViewController) {
        if viewController == entryViewController,
            let navigationController = viewController.navigationController,
            !(navigationController.topViewController is BRViewController)
        {
            cancelFlow()
        }
    }
}
