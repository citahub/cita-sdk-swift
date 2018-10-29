//
//  Transaction.swift
//  AppChain
//
//  Created by Yate Fulham on 2018/08/14.
//  Copyright © 2018 Cryptape. All rights reserved.
//

import Foundation
import BigInt

public enum TransactionError: Error {
    case privateKeyIsNull
    case signatureIncorrect
    case valueOverflow
    case unknownError
}

// AppChain Transaction
public struct Transaction: CustomStringConvertible {
    public var to: Address?
    public var nonce: String
    public var quota: UInt64
    public var validUntilBlock: UInt64
    public var data: Data?
    public var value: BigUInt // UInt256
    public var chainId: UInt32
    public var version: UInt32

    public init(
        to: Address? = nil,
        nonce: String,
        quota: UInt64 = 1_000_000,
        validUntilBlock: UInt64,
        data: Data? = nil,
        value: BigUInt = 0,
        chainId: UInt32,
        version: UInt32 = 0
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
            "quota: " + String(quota),
            "validUntilBlock: " + validUntilBlock.description,
            "data: " + (data?.toHexString() ?? "0x"),
            "value: " + value.description,
            "chainId: " + String(chainId),
            "version: " + String(version)
        ].joined(separator: "\n")
    }
}
