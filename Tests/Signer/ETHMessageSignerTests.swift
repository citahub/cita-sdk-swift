//
//  ETHMessageSignerTests.swift
//  NervosTests
//
//  Created by XiaoLu on 2018/10/22.
//  Copyright © 2018 Cryptape. All rights reserved.
//

import XCTest
@testable import Nervos

class ETHMessageSignerTest: XCTestCase {
    func testSignMessage() {
        let privateKey = "0xeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee"
        let data = Data.fromHex("6060604052341561000f57600080fd5b60d38061001d6000396000f3006060604052600436106049576000357c0100000000000000000000000000000000000000000000000000000000900463ffffffff16806360fe47b114604e5780636d4ce63c14606e575b600080fd5b3415605857600080fd5b606c60048080359060200190919050506094565b005b3415607857600080fd5b607e609e565b6040518082815260200191505060405180910390f35b8060008190555050565b600080549050905600a165627a7a723058202d9a0979adf6bf48461f24200e635bc19cd1786efbcfc0608eb1d76114d405860029")!
        guard let sign = try? ETHMessageSigner.sign(message: data, privateKey: privateKey) else {
            return XCTFail("Sign message failed")
        }
        XCTAssertEqual(sign, "")
    }

    func testSignPersonalMessage() {
//        0x46a23E25df9A0F6c18729ddA9Ad1aF3b6A131160
        let privateKey = "0xeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee"
        let data = Data.fromHex("6060604052341561000f57600080fd5b60d38061001d6000396000f3006060604052600436106049576000357c0100000000000000000000000000000000000000000000000000000000900463ffffffff16806360fe47b114604e5780636d4ce63c14606e575b600080fd5b3415605857600080fd5b606c60048080359060200190919050506094565b005b3415607857600080fd5b607e609e565b6040518082815260200191505060405180910390f35b8060008190555050565b600080549050905600a165627a7a723058202d9a0979adf6bf48461f24200e635bc19cd1786efbcfc0608eb1d76114d405860029")!
        guard let sign = try? ETHMessageSigner.signPersonalMessage(message: data, privateKey: privateKey) else {
            return XCTFail("Sign personal message failed")
        }
        XCTAssertEqual(sign, "")
    }
}
