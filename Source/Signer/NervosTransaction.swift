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
    case signatureFaild
    case unknownError
}

public struct NervosTransaction: CustomStringConvertible {
    public var to: Address
    public var nonce: BigUInt
    public var quota = BigUInt(100000)
    public var validUntilBlock: BigUInt
    public var version: BigUInt
    public var data: Data
    public var value: BigUInt
    public var chainId: BigUInt

    /*
    public init(to: Address, nonce: BigUInt, quota: BigUInt, validUntilBlock: BigUInt, version: BigUInt, data: Data, value: BigUInt, chainId: BigUInt) {
        self.nonce = nonce
        self.to = to
        self.quota = quota
        self.validUntilBlock = validUntilBlock
        self.version = version
        self.data = data
        self.value = value
        self.chainId = chainId
    }*/

    public var description: String {
        return [
            "Transaction",
            "nonce: " + String(nonce),
            "to: " + String(to.address),
            "quota: " + String(quota),
            "valid_until_block: " + String(validUntilBlock),
            "version: " + String(version),
            "data: " + data.toHexString(),
            "value: " + value.description,
            "chain_id: " + String(chainId)
        ].joined(separator: "\n")
    }

    static func createRawTransactionRequest(transaction: NervosTransaction, privateKey: String) -> Request? {
        let txSignStr = try! NervosTransactionSigner.sign(transaction: transaction, with: privateKey)
        var request = Request()
        request.method = Method.sendRawTransaction

        let params = [txSignStr] as [Encodable]
        let pars = Params(params: params)
        request.params = pars
        if !request.isValid { return nil }
        return request
    }
}
