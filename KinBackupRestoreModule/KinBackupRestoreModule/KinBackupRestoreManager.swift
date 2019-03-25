//
//  KinBackupRestoreManager.swift
//  KinEcosystem
//
//  Created by Corey Werner on 05/02/2019.
//  Copyright © 2019 Kin Foundation. All rights reserved.
//

import KinSDK

public protocol KinBackupRestoreManagerDelegate: NSObjectProtocol {
    /**
     Tells the delegate that the backup or restore process has completed.

     The `wasCancelled` parameter will be `true` if the user cancelled the process.

     - Parameter manager: The manager object providing this information.
     - Parameter wasCancelled: A `Bool` indicating whether the operation was cancelled or not.
     */
    func kinBackupRestoreManagerDidComplete(_ manager: KinBackupRestoreManager, wasCancelled: Bool)

    /**
     Tells the delegate that the backup or restore encountered an error.

     When an error is encountered, the backup or restore process will be stopped.

     - Parameter manager: The manager object providing this information.
     - Parameter error: The error which stopped the backup or restore process.
     */
    func kinBackupRestoreManager(_ manager: KinBackupRestoreManager, error: Error)
}

public class KinBackupRestoreManager: NSObject {
    public weak var delegate: KinBackupRestoreManagerDelegate?
    public weak var biDelegate: KinBackupRestoreBIDelegate? {
        didSet {
            KinBackupRestoreBI.shared.delegate = biDelegate
        }
    }

    private var instance: Instance?

    /**
     Backup an account by pushing the view controllers onto a navigation controller.

     If the navigation controller has a `topViewController`, then the stack will be popped to that
     view controller upon completion. Otherwise it's up to the user to perform the final navigation.

     - Parameter kinAccount: The `KinAccount` to backup.
     - Parameter navigationController: The navigation controller being pushed onto.

     - Returns: False if a session already exists, true otherwise.
     */
    @discardableResult
    public func backup(_ kinAccount: KinAccount, pushedOnto navigationController: UINavigationController) -> Bool {
        return start(with: .account(kinAccount), presentor: .pushedOnto(navigationController))
    }

    /**
     Backup an account by pushing the view controllers onto a navigation controller.

     - Parameter kinAccount: The `KinAccount` to backup.
     - Parameter viewController: The view controller being presented onto.

     - Returns: False if a session already exists, true otherwise.
     */
    @discardableResult
    public func backup(_ kinAccount: KinAccount, presentedOnto viewController: UIViewController) -> Bool {
        return start(with: .account(kinAccount), presentor: .presentedOnto(viewController))
    }

    /**
     Restore an account by presenting the navigation controller onto a view controller.

     If the navigation controller has a `topViewController`, then the stack will be popped to that
     view controller upon completion. Otherwise it's up to the user to perform the final navigation.

     - Parameter kinClient: The `KinClient` to restore into.
     - Parameter navigationController: The navigation controller being pushed onto.

     - Returns: False if a session already exists, true otherwise.
     */
    @discardableResult
    public func restore(_ kinClient: KinClient, pushedOnto navigationController: UINavigationController) -> Bool {
        return start(with: .client(kinClient), presentor: .pushedOnto(navigationController))
    }

    /**
     Restore an account by presenting the navigation controller onto a view controller.

     - Parameter kinClient: The `KinClient` to restore into.
     - Parameter viewController: The view controller being presented onto.

     - Returns: False if a session already exists, true otherwise.
     */
    @discardableResult
    public func restore(_ kinClient: KinClient, presentedOnto viewController: UIViewController) -> Bool {
        return start(with: .client(kinClient), presentor: .presentedOnto(viewController))
    }

    private func start(with connector: Connector, presentor: Presentor) -> Bool {
        guard instance == nil else {
            return false
        }

        let flowController: FlowController

        switch presentor {
        case .pushedOnto(let navigationController):
            flowController = createFlowController(with: connector, navigationController: navigationController)
            push(flowController, onto: navigationController)

        case .presentedOnto(let viewController):
            let navigationController = UINavigationController()
            flowController = createFlowController(with: connector, navigationController: navigationController)
            present(flowController, onto: viewController)
        }

        instance = Instance(connector: connector, presentor: presentor, flowController: flowController)

        return true
    }

    private func createFlowController(with connector: Connector, navigationController: UINavigationController) -> FlowController {
        let controller: FlowController

        switch connector {
        case .client(let kinClient):
            controller = RestoreFlowController(kinClient: kinClient, navigationController: navigationController)
        case .account(let kinAccount):
            controller = BackupFlowController(kinAccount: kinAccount, navigationController: navigationController)
        }

        controller.delegate = self
        return controller
    }

    private func push(_ flowController: FlowController, onto navigationController: UINavigationController) {
        let isStackEmpty = navigationController.viewControllers.isEmpty

        navigationController.pushViewController(flowController.entryViewController, animated: !isStackEmpty)
    }

    private func present(_ flowController: FlowController, onto viewController: UIViewController) {
        let dismissItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: flowController, action: #selector(flowController.cancelFlow))
        flowController.entryViewController.navigationItem.leftBarButtonItem = dismissItem
        flowController.navigationController.viewControllers = [flowController.entryViewController]
        viewController.present(flowController.navigationController, animated: true)
    }
}

// MARK: - Types

extension KinBackupRestoreManager {
    fileprivate enum Connector {
        case client(_ kinClient: KinClient)
        case account(_ kinAccount: KinAccount)
    }

    fileprivate enum Presentor {
        case pushedOnto(_ navigationController: UINavigationController)
        case presentedOnto(_ viewController: UIViewController)
    }

    fileprivate class Instance {
        let connector: Connector
        let presentor: Presentor
        let flowController: FlowController

        init(connector: Connector, presentor: Presentor, flowController: FlowController) {
            self.connector = connector
            self.presentor = presentor
            self.flowController = flowController
        }
    }
}

// MARK: - Navigation

extension KinBackupRestoreManager {
    private var navigationController: UINavigationController? {
        return instance?.flowController.navigationController
    }
    
    private func dismissFlow() {
        if let presentor = instance?.presentor, case let Presentor.presentedOnto(viewController) = presentor {
            viewController.dismiss(animated: true)
        }
    }
    
    private func popNavigationStackIfNeeded() {
        guard let flowController = instance?.flowController else {
            return
        }
        
        let navigationController = flowController.navigationController
        let entryViewController = flowController.entryViewController
        
        guard let index = navigationController.viewControllers.index(of: entryViewController) else {
            return
        }
        
        if index > 0 {
            let externalViewController = navigationController.viewControllers[index - 1]
            navigationController.popToViewController(externalViewController, animated: true)
        }
    }
}

// MARK: - Flow

extension KinBackupRestoreManager: FlowControllerDelegate {
    func flowControllerDidComplete(_ controller: FlowController) {
        guard let instance = instance else {
            return
        }

        delegate?.kinBackupRestoreManagerDidComplete(self, wasCancelled: false)

        switch instance.presentor {
        case .pushedOnto:
            popNavigationStackIfNeeded()
        case .presentedOnto:
            dismissFlow()
        }
        
        self.instance = nil
    }
    
    func flowControllerDidCancel(_ controller: FlowController) {
        guard let instance = instance else {
            return
        }

        delegate?.kinBackupRestoreManagerDidComplete(self, wasCancelled: true)

        switch instance.presentor {
        case .pushedOnto:
            break
        case .presentedOnto:
            dismissFlow()
        }
        
        self.instance = nil
    }
}
