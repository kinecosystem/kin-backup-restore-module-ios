//
//  MainNavigationController.swift
//  KinMigrationSampleApp
//
//  Created by Corey Werner on 13/12/2018.
//  Copyright © 2018 Kin Foundation. All rights reserved.
//

import UIKit
import KinSDK
import KinBackupRestoreModule

class MainNavigationController: UINavigationController {
    let network: Network = .testNet
    var brManager: BRManager! // TODO: change init to not require self
    var brAccount: KinAccount?

    private let loaderView = UIActivityIndicatorView(style: .whiteLarge)

    convenience init() {
        self.init(nibName: nil, bundle: nil)
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)

        let appId: AppId

        do {
            appId = try AppId(network: network)
        }
        catch {
            fatalError()
        }

        brManager = BRManager(with: self)

        let kinClient = KinClient(with: .blockchain(network), network: network, appId: appId)
        let accountListViewController = AccountListViewController(with: kinClient)
        accountListViewController.title = "Accounts"
        accountListViewController.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Restore", style: .plain, target: self, action: #selector(restoreAction))
        accountListViewController.delegate = self

        viewControllers = [accountListViewController]
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Account List View Controller

extension MainNavigationController: AccountListViewControllerDelegate {
    func accountListViewController(_ viewController: AccountListViewController, didSelect account: KinAccount) {
        let viewController = AccountViewController(account, network: network)
        viewController.delegate = self
        pushViewController(viewController, animated: true)
    }
}

// MARK: - Account View Controller

extension MainNavigationController: AccountViewControllerDelegate {
    func accountViewController(_ viewController: AccountViewController, backupAccount account: KinAccount) {
        brAccount = account

        brManager.start(.backup, pushedOnto: self, events: { events in
            print("||| event")
        }) { completion in
            print("||| completed")

            self.brAccount = nil
        }
    }
}

// MARK: - Backup and Restore

extension MainNavigationController: KeystoreProvider {
    @objc fileprivate func restoreAction() {
        brManager.start(.restore, presentedOn: self, events: { events in
            print("||| event")
        }) { completion in
            print("||| completed")
        }
    }

    func exportAccount(_ password: String) throws -> String {
        guard let brAccount = brAccount else {
            fatalError()
        }

        return try brAccount.export(passphrase: password)
    }

    func importAccount(keystore: String, password: String, completion: @escaping (Error?) -> ()) {
        completion(nil)
    }

    func validatePassword(_ password: String) -> Bool {
        return true
    }
}

// MARK: - Loader

extension MainNavigationController {
    fileprivate func presentLoaderView() {
        guard loaderView.superview == nil else {
            return
        }

        loaderView.backgroundColor = UIColor(white: 0, alpha: 0.5)
        loaderView.translatesAutoresizingMaskIntoConstraints = false
        loaderView.startAnimating()
        view.addSubview(loaderView)
        loaderView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        loaderView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        loaderView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        loaderView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }

    fileprivate func dismissLoaderView() {
        guard loaderView.superview != nil else {
            return
        }

        loaderView.stopAnimating()
        loaderView.removeFromSuperview()
    }
}
