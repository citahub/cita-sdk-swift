//
//  Unsigner.swift
//  CITA
//
//  Created by James Chen on 2018/09/07.
//  Copyright © 2018 Cryptape. All rights reserved.
//

import Foundation
import BigInt

// CITA Transaction Unsigner for recovering tx and public key from a signed tx.
public struct Unsigner {
    public init() {}

    /// Unsign a signed transaction.
    public func unsign(signed: String) throws -> UnsignedTransaction {
        guard let data = Data.fromHex(signed) else {
            throw TransactionError.signatureIncorrect
        }

        let unverifiedTransaction = try CitaUnverifiedTransaction(serializedData: data)
        let binaryData = try! unverifiedTransaction.transaction.serializedData()
        let hash = binaryData.sha3(.keccak256)

        guard let publicKey = try? Secp256k1.recoverPublicKey(hash: hash, signature: unverifiedTransaction.signature) else {
            throw TransactionError.signatureIncorrect
        }

        return UnsignedTransaction(tx: unverifiedTransaction.transaction, publicKey: publicKey)
    }
}

public struct UnsignedTransaction {
    public struct Sender {
        public let address: String
        public let publicKey: Data
    }

    public let transaction: Transaction
    public let sender: Sender

    init(tx: CitaTransaction, publicKey: Data) {
        transaction = Transaction(
            to: Address(tx.parsedTo.addHexPrefix()),
            nonce: tx.nonce,
            quota: tx.quota,
            validUntilBlock: tx.validUntilBlock,
            data: tx.data,
            value: BigUInt.fromHex(tx.value.toHexString())!,
            chainId: tx.parsedChainId,
            version: tx.version
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
            return try Unsigner().unsign(signed: content)
        } catch {
            return nil
        }
    }
}
