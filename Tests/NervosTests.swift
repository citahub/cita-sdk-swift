//
//  NervosTests.swift
//  NervosTests
//
//  Created by Yate Fulham on 2018/08/10.
//  Copyright © 2018 Cryptape. All rights reserved.
//

import XCTest
@testable import Nervos

class NervosTests: XCTestCase {
    func testDefaultInstance() {
        XCTAssertNotNil(Nervos.default)
    }
}
