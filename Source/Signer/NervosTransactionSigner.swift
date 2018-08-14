//
//  NervosTransactionSigner.swift
//  Nervos
//
//  Created by Yate Fulham on 2018/08/14.
//  Copyright © 2018 Cryptape. All rights reserved.
//

import Foundation

public struct NervosTransactionSigner {
    public static func sign(transaction: NervosTransaction, with privateKey: String) throws -> String {
        var tx = Transaction()
        tx.nonce = transaction.description
        tx.to = transaction.to.address
        tx.quota = UInt64(transaction.quota)
        tx.data = transaction.data
        tx.version = UInt32(transaction.version)
        tx.value = Data(hex: transaction.value.toHexString())
        tx.chainID = UInt32(transaction.chainId)
        tx.validUntilBlock = UInt64(transaction.validUntilBlock)
        let binaryData: Data = try! tx.serializedData()
        guard let privateKeyData = Data.fromHex(privateKey) else {
            throw TransactionError.privateKeyIsNull
        }
        let protobufHash = binaryData.sha3(.keccak256)
        let (compressedSignature, _) = Secp256k1.signForRecovery(hash: protobufHash, privateKey: privateKeyData, useExtraEntropy: false)
        guard let signature = compressedSignature else {
            throw TransactionError.unknownError
        }

        var unverifiedTx = UnverifiedTransaction()
        unverifiedTx.transaction = tx
        unverifiedTx.signature = signature
        unverifiedTx.crypto = .secp
        let unverifiedData: Data = try! unverifiedTx.serializedData()
        return unverifiedData.toHexString().addHexPrefix()
    }
}
