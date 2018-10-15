//
//  NervosTransactionSigner.swift
//  Nervos
//
//  Created by Yate Fulham on 2018/08/14.
//  Copyright © 2018 Cryptape. All rights reserved.
//

import Foundation
import BigInt

public struct NervosTransactionSigner {
    // Sign a transaction using private key.
    // Value of transaction may not exceed max of UInt256.
    public static func sign(transaction: NervosTransaction, with privateKey: String) throws -> String {
        guard let value = convert(value: transaction.value) else {
            throw TransactionError.valueOverflow
        }
        var tx = Transaction()

        tx.nonce = transaction.nonce
        if let to = transaction.to {
            tx.to = to.address.stripHexPrefix().lowercased()
        }
        tx.quota = transaction.quota
        tx.data = transaction.data ?? Data()
        tx.version = transaction.version
        tx.value = value
        tx.chainID = transaction.chainId
        tx.validUntilBlock = transaction.validUntilBlock

        let binaryData = try! tx.serializedData()
        guard let privateKeyData = Data.fromHex(privateKey) else {
            throw TransactionError.privateKeyIsNull
        }
        let protobufHash = binaryData.sha3(.keccak256)
        let (compressedSignature, _) = Secp256k1.signForRecovery(hash: protobufHash, privateKey: privateKeyData, useExtraEntropy: false)
        guard let signature = compressedSignature else {
            throw TransactionError.signatureIncorrect
        }

        var unverifiedTx = UnverifiedTransaction()
        unverifiedTx.transaction = tx
        unverifiedTx.signature = signature
        unverifiedTx.crypto = .secp
        let unverifiedData = try! unverifiedTx.serializedData()
        return unverifiedData.toHexString().addHexPrefix()
    }

    // Convert value to bytes32
    // - Returns: Bytes32 data, or nil if value is larger than 256bit max.
    // Value must be encoded as fixed length (32) bytes
    static func convert(value: BigUInt) -> Data? {
        if let hex = value.toUInt256Hex() {
            return Data.fromHex(hex)!
        }

        return nil
    }
}
