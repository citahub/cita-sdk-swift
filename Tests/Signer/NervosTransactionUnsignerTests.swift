//
//  NervosTransactionUnsignerTests.swift
//  AppChainTests
//
//  Created by James Chen on 2018/09/07.
//  Copyright © 2018 Cryptape. All rights reserved.
//

import XCTest
import BigInt
@testable import AppChain

class NervosTransactionUnsignerTests: XCTestCase {
    func testUnsignTx() {
        let privateKey = "0xeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee"
        let tx = NervosTransaction(
            to: Address("0x0000000000000000000000000000000000000000")!,
            nonce: "12345",
            validUntilBlock: 999999,
            data: Data.fromHex("6060604052341561000f57600080fd5b5b60646000819055507f8fb1356be6b2a4e49ee94447eb9dcb8783f51c41dcddfe7919f945017d163bf3336064604051808373ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1681526020018281526020019250505060405180910390a15b5b610178806100956000396000f30060606040526000357c0100000000000000000000000000000000000000000000000000000000900463ffffffff16806360fe47b1146100495780636d4ce63c1461006c575b600080fd5b341561005457600080fd5b61006a6004808035906020019091905050610095565b005b341561007757600080fd5b61007f610142565b6040518082815260200191505060405180910390f35b7fc6d8c0af6d21f291e7c359603aa97e0ed500f04db6e983b9fce75a91c6b8da6b816040518082815260200191505060405180910390a1806000819055507ffd28ec3ec2555238d8ad6f9faf3e4cd10e574ce7e7ef28b73caa53f9512f65b93382604051808373ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1681526020018281526020019250505060405180910390a15b50565b6000805490505b905600a165627a7a723058207fbd8b51e2ecdeb2425f642d6602a4ff030351102fd7afbed80318e61fa462670029")!,
            chainId: 1
        )
        let signed = try! NervosTransactionSigner.sign(transaction: tx, with: privateKey)

        let unsiged = try! NervosTransactionUnsigner.unsign(signed: signed)
        XCTAssertEqual(unsiged.transaction.to, tx.to)
        XCTAssertEqual(unsiged.transaction.nonce, tx.nonce)
        XCTAssertEqual(unsiged.transaction.quota, tx.quota)
        XCTAssertEqual(unsiged.transaction.value, tx.value)
        XCTAssertEqual(unsiged.transaction.validUntilBlock, tx.validUntilBlock)
        XCTAssertEqual(unsiged.transaction.chainId, tx.chainId)
        XCTAssertEqual(unsiged.transaction.version, tx.version)
    }

    func testUnsignValue() {
        let privateKey = "0xeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee"
        let values: [BigUInt] = [
            0,
            1,
            2,
            50,
            BigUInt(10).power(18)
        ]
        values.forEach { value in
            let tx = NervosTransaction(nonce: "\(value)", validUntilBlock: 999_999, value: value, chainId: 1)
            let signed = try! NervosTransactionSigner.sign(transaction: tx, with: privateKey)
            let unsiged = try! NervosTransactionUnsigner.unsign(signed: signed)
            XCTAssertEqual(unsiged.transaction.value, tx.value)
        }
    }

    func testUnsignContent() {
        let unsigned = try! NervosTransactionUnsigner.unsign(signed: "0x0ac1021220353761343535383934386562343232626162333666316361306630333534653718c0843d20e9df592af0016060604052341561000f57600080fd5b60d38061001d6000396000f3006060604052600436106049576000357c0100000000000000000000000000000000000000000000000000000000900463ffffffff16806360fe47b114604e5780636d4ce63c14606e575b600080fd5b3415605857600080fd5b606c60048080359060200190919050506094565b005b3415607857600080fd5b607e609e565b6040518082815260200191505060405180910390f35b8060008190555050565b600080549050905600a165627a7a723058202d9a0979adf6bf48461f24200e635bc19cd1786efbcfc0608eb1d76114d40586002932200000000000000000000000000000000000000000000000000000000000000000380112410167c108d0919a02a43219e3a52fe3cddbe0ac8b9d2271f429c2b09cdad481536596976aa166e66d2b30451a54e1a405bfbc5780538abf0caedbddd4dcbf732200")
        XCTAssertEqual(unsigned.transaction.quota, 1_000_000)
    }

    func testUnsignBadData() {
        do {
            let _ = try NervosTransactionUnsigner.unsign(signed: "oh no")
            XCTFail("Unsign should fail")
        } catch let err {
            XCTAssertEqual(err.localizedDescription, TransactionError.signatureIncorrect.localizedDescription)
        }
    }
}
