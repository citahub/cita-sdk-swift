//
//  CITATests.swift
//  CITATests
//
//  Created by Yate Fulham on 2018/08/10.
//  Copyright © 2018 Cryptape. All rights reserved.
//

import XCTest
@testable import CITA

class CITATests: XCTestCase {
    func testDefaultInstance() {
        XCTAssertEqual(cita.provider.url, CITA.default.provider.url)
    }
}
