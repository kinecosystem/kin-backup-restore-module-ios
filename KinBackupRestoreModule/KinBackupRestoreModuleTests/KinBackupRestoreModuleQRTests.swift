//
//  KinBackupRestoreModuleQRTests.swift
//  KinBackupRestoreModuleTests
//
//  Created by Corey Werner on 26/03/2019.
//  Copyright © 2019 Kin Foundation. All rights reserved.
//

import XCTest
@testable import KinBackupRestoreModule

class KinBackupRestoreModuleQRTests: XCTestCase {
    func testQR() {
        let string = "A random string to test"

        guard let qrImage = QRController.encode(string: string) else {
            XCTAssertTrue(false, "Could not encode QR string")
            return
        }

        guard let qrString = QRController.decode(image: qrImage) else {
            XCTAssertTrue(false, "Could not decode QR image")
            return
        }

        XCTAssertTrue(string == qrString, "Strings do not match")
    }
}
