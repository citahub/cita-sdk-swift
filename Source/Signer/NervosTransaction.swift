//
//  NervosTransaction.swift
//  Nervos
//
//  Created by Yate Fulham on 2018/08/14.
//  Copyright © 2018 Cryptape. All rights reserved.
//

import Foundation
import BigInt

public enum TransactionError: Error {
    case privateKeyIsNull
    case signatureIncorrect
    case unknownError
}

public struct NervosTransaction: CustomStringConvertible {
    public var to: Address?
    public var nonce: String
    public var quota: BigUInt
    public var validUntilBlock: BigUInt
    public var data: Data?
    public var value: BigUInt // UInt256
    public var chainId: BigUInt
    public var version: BigUInt

    public init(
        to: Address? = nil,
        nonce: String,
        quota: BigUInt = 1_000_000,
        validUntilBlock: BigUInt,
        data: Data? = nil,
        value: BigUInt = 0,
        chainId: BigUInt,
        version: BigUInt = 0
    ) {
        self.to = to
        self.nonce = nonce
        self.quota = quota
        self.validUntilBlock = validUntilBlock
        self.data = data
        self.value = value
        self.chainId = chainId
        self.version = version
    }

    public var description: String {
        return [
            "Transaction",
            "to: " + (to?.address ?? ""),
            "nonce: " + nonce,
            "data: " + (data?.toHexString() ?? "0x"),
            "value: " + value.description,
            "validUntilBlock: " + validUntilBlock.description,
            "quota: " + String(quota),
            "version: " + String(version),
            "chainId: " + String(chainId)
        ].joined(separator: "\n")
    }
}
