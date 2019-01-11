//
//  HTTPProviderTests.swift
//  CITATests
//
//  Created by Yate Fulham on 2018/08/09.
//  Copyright © 2018 Cryptape. All rights reserved.
//

import XCTest
@testable import CITA

class HTTPProviderTests: XCTestCase {
    func testDefaultProvider() {
        XCTAssertNotNil(HTTPProvider.testnetURL)
    }

    func testOnlySupportHTTP() {
        XCTAssertNil(HTTPProvider(URL(string: "ftp://127.0.0.1")!))
    }
}
