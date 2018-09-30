//
//  IntExtensionTests.swift
//  NervosTests
//
//  Created by James Chen on 2018/09/19.
//  Copyright © 2018 Cryptape. All rights reserved.
//

import XCTest
import BigInt
@testable import Nervos

class IntExtensionTests: XCTestCase {
    func testToUInt256Hex() {
        let values: [BigUInt: String] = [
            0:                                          "0000000000000000000000000000000000000000000000000000000000000000",
            1:                                          "0000000000000000000000000000000000000000000000000000000000000001",
            BigUInt(10).power(18):                      "0000000000000000000000000000000000000000000000000de0b6b3a7640000",
            BigUInt("10", radix: 2)!.power(256) - 1:    "ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff",
            BigUInt("10", radix: 2)!.power(256):        "0000000000000000000000000000000000000000000000000000000000000000"
        ]
        values.forEach { value, hex in
            XCTAssertEqual(value.toUInt256Hex(), hex)
        }
    }

    func testBigIntToHex() {
        [
            0,
            1,
            1_000,
            1_000_000
        ].forEach { value in
            let bigInt = BigUInt(value)
            XCTAssertEqual(BigUInt.fromHex(bigInt.toHexString())!, bigInt)
        }
    }
}
