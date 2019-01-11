//
//  Transaction.swift
//  CITA
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
    case versionNotSupported
    case chainIdInvalid
}

// CITA (CITA) Transaction
public struct Transaction: CustomStringConvertible {
    public var to: Address?
    public var nonce: String
    public var quota: UInt64
    public var validUntilBlock: UInt64
    public var data: Data?
    public var value: BigUInt   // UInt256
    public var chainId: String  // Hex format, underlying type is UInt256.
    public var version: UInt32

    public init(
        to: Address? = nil,
        nonce: String,
        quota: UInt64 = 53_000,
        validUntilBlock: UInt64,
        data: Data? = nil,
        value: BigUInt = 0,
        chainId: String,
        version: UInt32 = 1
    ) {
        self.to = to
        self.nonce = nonce.isEmpty ? UUID().uuidString : nonce
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
            "chainId: " + chainId,
            "version: " + String(version)
        ].joined(separator: "\n")
    }
}

extension CitaTransaction {
    var parsedTo: String {
        switch version {
        case 0:
            return to
        case 1:
            return toV1.toHexString()
        default:
            fatalError("Transaction version not supported")
        }
    }
    var parsedChainId: String {
        switch version {
        case 0:
            return String(chainID)
        case 1:
            return chainIDV1.toHexString()
        default:
            fatalError("Transaction version not supported")
        }
    }
}
