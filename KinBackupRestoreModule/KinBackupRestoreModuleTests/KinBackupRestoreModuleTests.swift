//
//  KinBackupRestoreModuleTests.swift
//  KinBackupRestoreModuleTests
//
//  Created by Corey Werner on 03/02/2019.
//  Copyright © 2019 Kin Foundation. All rights reserved.
//

import XCTest
@testable import KinBackupRestoreModule
@testable import KinSDK

class KinBackupRestoreModuleTests: XCTestCase {
    var client: KinClient?

    override func setUp() {
        let url = URL(string: "https://horizon-testnet.kininfrastructure.com")!
        let appId = try! AppId("test")
        client = KinClient(with: url, network: .testNet, appId: appId)
    }

    override func tearDown() {
        client?.deleteKeystore()
    }

    func testBackup() {
        guard let client = client else {
            XCTAssertTrue(false, "Client doesn't exist")
            return
        }

        let account: KinAccount

        do {
            account = try client.addAccount()
        }
        catch {
            XCTAssertTrue(false, error.localizedDescription)
        }

        let brManager = KinBackupRestoreManager()
//        brManager.backup(account, presentedOnto: <#T##UIViewController#>)

    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
