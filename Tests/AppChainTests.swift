//
//  AppChainTests.swift
//  AppChainTests
//
//  Created by Yate Fulham on 2018/08/10.
//  Copyright © 2018 Cryptape. All rights reserved.
//

import XCTest
@testable import AppChain

class AppChainTests: XCTestCase {
    func testDefaultInstance() {
        XCTAssertEqual(appChain.provider.url, AppChain.default.provider.url)
    }
}
