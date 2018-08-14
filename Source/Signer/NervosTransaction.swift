//
//  NervosTransaction.swift
//  Nervos
//
//  Created by Yate Fulham on 2018/08/14.
//  Copyright © 2018 Cryptape. All rights reserved.
//

import Foundation
import BigInt
import secp256k1_ios

public enum TransactionError: Error {
    case privateKeyIsNull
    case signatureIncorrect
    case unknownError
}

public struct NervosTransaction: CustomStringConvertible {
    public var to: Address
    public var nonce: String
    public var data: Data
    public var value: BigUInt
    public var validUntilBlock: BigUInt
    public var quota: BigUInt
    public var version: BigUInt
    public var chainId: BigUInt

    public init(
        to: Address,
        nonce: String,
        data: Data,
        value: BigUInt = 0,
        validUntilBlock: BigUInt,
        quota: BigUInt = 100000,
        version: BigUInt = 0,
        chainId: BigUInt
    ) {
        self.to = to
        self.nonce = nonce
        self.data = data
        self.value = value
        self.validUntilBlock = validUntilBlock
        self.quota = quota
        self.version = version
        self.chainId = chainId
    }

    public var description: String {
        return [
            "Transaction",
            "to: " + to.address,
            "nonce: " + nonce,
            "data: " + data.toHexString(),
            "value: " + value.description,
            "validUntilBlock: " + validUntilBlock.description,
            "quota: " + String(quota),
            "version: " + String(version),
            "chainId: " + String(chainId)
        ].joined(separator: "\n")
    }
}
