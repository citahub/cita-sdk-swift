//
//  UtilsTests.swift
//  NervosTests
//
//  Created by James Chen on 2018/10/01.
//  Copyright © 2018 Cryptape. All rights reserved.
//

import XCTest
@testable import Nervos

class UtilsTests: XCTestCase {
    func testGetQuotaPrice() {
        let result = Utils.getQuotaPrice(nervos: nervos)
        switch result {
        case .success(let quotaPrice):
            XCTAssertTrue(quotaPrice >= 0)
        case .failure(let error):
            XCTFail(error.localizedDescription)
        }
    }
}
