//
//  AppChainTests.swift
//  NervosTests
//
//  Created by Yate Fulham on 2018/08/10.
//  Copyright © 2018 Cryptape. All rights reserved.
//

import XCTest
@testable import Nervos

class AppChainTests: XCTestCase {
    func testPeerCount() {
        let result = nervos.appChain.peerCount()
        switch result {
        case .success(let count):
            XCTAssertTrue(count >= 0)
        case .failure(let error):
            XCTFail(error.localizedDescription)
        }
    }

    func testPeerCountFailure() {
        let result = nobody.appChain.peerCount()
        switch result {
        case .success(let count):
            XCTFail("Should not get peerCount \(count) from an invalid nervos node")
        case .failure(let error):
            XCTAssertNotNil(error)
        }
    }
}
