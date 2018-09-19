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
    public static func sign(transaction: NervosTransaction, with privateKey: String) throws -> String {
        var tx = Transaction()
        tx.nonce = transaction.nonce
        if let to = transaction.to {
            tx.to = to.address.stripHexPrefix().lowercased()
        }
        tx.quota = UInt64(transaction.quota)
        tx.data = transaction.data ?? Data()
        tx.version = UInt32(transaction.version)
        tx.value = convert(value: transaction.value)
        tx.chainID = UInt32(transaction.chainId)
        tx.validUntilBlock = UInt64(transaction.validUntilBlock)

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

    /// Value must be encoded as fixed length (32) bytes
    static func convert(value: BigUInt) -> Data {
        let bytes = [UInt8](hex: value.toHexString())
        assert(bytes.count <= 32)
        let padding = [UInt8](repeating: 0, count: 32 - bytes.count)
        return Data(bytes: padding + bytes)
    }
}
