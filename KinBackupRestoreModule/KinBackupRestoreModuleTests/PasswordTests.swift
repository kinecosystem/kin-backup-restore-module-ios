//
//  PasswordTests.swift
//  KinBackupRestoreModuleTests
//
//  Created by Corey Werner on 26/03/2019.
//  Copyright © 2019 Kin Foundation. All rights reserved.
//

import XCTest
@testable import KinBackupRestoreModule

class PasswordTests: XCTestCase {
    func testValidPassword() {
        XCTAssertNoThrow(try Password.matches(""))
    }

    func testInvalidPassword() {
        XCTAssertThrowsError(try Password.matches(""))
        XCTAssertThrowsError(try Password.matches("aaaaaaaa"))
    }
}
