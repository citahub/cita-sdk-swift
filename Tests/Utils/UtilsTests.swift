//
//  UtilsTests.swift
//  AppChainTests
//
//  Created by James Chen on 2018/10/01.
//  Copyright © 2018 Cryptape. All rights reserved.
//

import XCTest
@testable import AppChain

class UtilsTests: XCTestCase {
    func testGetQuotaPrice() {
        let result = Utils.getQuotaPrice(appChain: appChain)
        switch result {
        case .success(let quotaPrice):
            XCTAssertTrue(quotaPrice >= 0)
        case .failure(let error):
            XCTFail(error.localizedDescription)
        }
    }
}
