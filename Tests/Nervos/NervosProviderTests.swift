//
//  NervosProviderTests.swift
//  AppChainTests
//
//  Created by Yate Fulham on 2018/08/09.
//  Copyright © 2018 Cryptape. All rights reserved.
//

import XCTest
@testable import AppChain

class NervosProviderTests: XCTestCase {
    func testDefaultProvider() {
        XCTAssertNotNil(NervosProvider.testnetProviderURL)
    }

    func testOnlySupportHTTP() {
        XCTAssertNil(NervosProvider(URL(string: "ftp://127.0.0.1")!))
    }
}
