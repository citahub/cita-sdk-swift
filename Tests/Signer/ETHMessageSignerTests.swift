//
//  ETHMessageSignerTests.swift
//  AppChainTests
//
//  Created by XiaoLu on 2018/10/22.
//  Copyright © 2018 Cryptape. All rights reserved.
//

import XCTest
@testable import AppChain

class ETHMessageSignerTest: XCTestCase {
    func testSignMessage() {
        let privateKey = "0xeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee"
        let data = "This is a sweet message".data(using: .utf8)!
        guard let sign = try? ETHMessageSigner.sign(message: data, privateKey: privateKey, useExtraEntropy: false) else {
            return XCTFail("Sign message failed")
        }
        XCTAssertEqual(sign, "0xd3ea800844eb6e1c05b208073777dee7c33d415c770278502226e437839766d23dfc9bbbdd8bf747392feb1dd12be8a020c77c4756c7838f4f032dbcc211798c1b")
    }

    func testSignPersonalMessage() {
        let privateKey = "0xeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee"
        let data = "This is a sweet message".data(using: .utf8)!
        guard let sign = try? ETHMessageSigner.signPersonalMessage(message: data, privateKey: privateKey, useExtraEntropy: false) else {
            return XCTFail("Sign personal message failed")
        }
        XCTAssertEqual(sign, "0x3065bbd1cf6d80e7e60faf9688b9a75e6d52104a501168eccfa7ef51228c7b727f7a17dc87902d6619a7c00475bc62370dc123e6e71a6ae528d7674a4086614b1c")
    }

    func testHashMessage() {
        let fixtures: [Data: String] = [
            "hello world".data(using: .utf8)!: "0x47173285a8d7341e5e972fc677286384f802f8ef42a5ec5f03bbfa254cb01fad",
            Data.fromHex("0x47173285a8d7341e5e972fc677286384f802f8ef42a5ec5f03bbfa254cb01fad")!: "0x04cd40a3ea7972c6f30142d02fd5ddcac438fe6c59e634cecb827fbee9d385fc",
        ]
        for (data, hash) in fixtures {
            XCTAssertEqual(hash, ETHMessageSigner.hashMessage(data).toHexString().addHexPrefix())
        }
    }

    func testHashPersonalMessage() {
        let fixtures: [Data: String] = [
            "hello world".data(using: .utf8)!: "0xd9eba16ed0ecae432b71fe008c98cc872bb4cc214d3220a36f365326cf807d68",
            Data.fromHex("0x47173285a8d7341e5e972fc677286384f802f8ef42a5ec5f03bbfa254cb01fad")!: "0x93100cc9477ba6522a2d7d5e83d0e075b167224ed8aa0c5860cfd47fa9f22797",
            // Data.fromHex("0x7f23b5eed5bc7e89f267f339561b2697faab234a2")!: "0x06c9d148d268f9a13d8f94f4ce351b0beff3b9ba69f23abbf171168202b2dd67", see https://github.com/ethers-io/ethers.js/issues/85
        ]
        for (data, hash) in fixtures {
            XCTAssertEqual(hash, ETHMessageSigner.hashPersonalMessage(data)!.toHexString().addHexPrefix())
        }
    }
}
