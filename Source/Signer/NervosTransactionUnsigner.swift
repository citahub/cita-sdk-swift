//
//  NervosTransactionUnsigner.swift
//  Nervos
//
//  Created by James Chen on 2018/09/07.
//  Copyright © 2018 Cryptape. All rights reserved.
//

import Foundation
import BigInt

public struct NervosTransactionUnsigner {
    /// Unsign a signed transaction.
    public static func unsign(signed: String) throws -> UnsignedTransaction {
        guard let data = Data.fromHex(signed) else {
            throw TransactionError.signatureIncorrect
        }

        let unverifiedTransaction = try UnverifiedTransaction(serializedData: data)
        let binaryData = try! unverifiedTransaction.transaction.serializedData()
        let hash = binaryData.sha3(.keccak256)

        guard let publicKey = Secp256k1.recoverPublicKey(hash: hash, signature: unverifiedTransaction.signature) else {
            throw TransactionError.signatureIncorrect
        }

        return UnsignedTransaction(unverifiedTransaction: unverifiedTransaction.transaction, publicKey: publicKey)
    }
}

public struct UnsignedTransaction {
    public struct Sender {
        public let address: String
        public let publicKey: Data
    }

    public let transaction: NervosTransaction
    public let sender: Sender

    init(unverifiedTransaction tx: Transaction, publicKey: Data) {
        transaction = NervosTransaction(
            to: Address(tx.to.addHexPrefix())!,
            nonce: tx.nonce,
            quota: BigUInt(tx.quota),
            validUntilBlock: BigUInt(tx.validUntilBlock),
            data: tx.data,
            value: BigUInt.fromHex(tx.value.toHexString())!,
            chainId: BigUInt(tx.chainID),
            version: BigUInt(tx.version)
        )
        sender = Sender(
            address: Utils.publicToAddress(publicKey)!.address.lowercased(),
            publicKey: publicKey
        )
    }
}

extension TransactionDetails {
    public var unsignedTransaction: UnsignedTransaction? {
        do {
            return try NervosTransactionUnsigner.unsign(signed: content)
        } catch {
            return nil
        }
    }
}
