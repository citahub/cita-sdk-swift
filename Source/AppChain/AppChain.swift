//
//  AppChain.swift
//  Nervos
//
//  Created by Yate Fulham on 2018/08/10.
//  Copyright © 2018 Cryptape. All rights reserved.
//

import Foundation
import web3swift
import BigInt
import Result

public class AppChain: Web3OptionsInheritable {
    var provider: NervosProvider
    weak var nervos: Nervos?

    public var options: Web3Options {
        return nervos!.options
    }

    public init(provider: NervosProvider, nervos: Nervos) {
        self.provider = provider
        self.nervos = nervos
    }
}

// API
extension AppChain {
    public func peerCount() -> Result<BigUInt, NervosError> {
        return Result.failure(NervosError.processingError("Not implemented"))
    }

    public func blockNumber() -> Result<BigUInt, NervosError> {
        return Result.failure(NervosError.processingError("Not implemented"))
    }

    public func sendRawTransaction(_ transaction: EthereumTransaction) -> Result<TransactionSendingResult, NervosError> {
        return Result.failure(NervosError.processingError("Not implemented"))
    }

    public func sendRawTransaction(_ transaction: EthereumTransaction, privateKey: String) -> Result<TransactionSendingResult, NervosError> {
        return Result.failure(NervosError.processingError("Not implemented"))
    }

    public func getBlockByHash(_ hash: String, fullTransactions: Bool = false) -> Result<Block, NervosError> {
        return Result.failure(NervosError.processingError("Not implemented"))
    }

    public func getBlockByHash(_ hash: Data, fullTransactions: Bool = false) -> Result<Block, NervosError> {
        return Result.failure(NervosError.processingError("Not implemented"))
    }

    public func getBlockByNumber(_ number: UInt64, fullTransactions: Bool = false) -> Result<Block, NervosError> {
        return Result.failure(NervosError.processingError("Not implemented"))
    }

    public func getBlockByNumber(_ number: BigUInt, fullTransactions: Bool = false) -> Result<Block, NervosError> {
        return Result.failure(NervosError.processingError("Not implemented"))
    }

    public func getBlockByNumber(_ block: String, fullTransactions: Bool = false) -> Result<Block, NervosError> {
        return Result.failure(NervosError.processingError("Not implemented"))
    }

    public func getTransactionReceipt(_ txhash: Data) -> Result<TransactionReceipt, NervosError> {
        return Result.failure(NervosError.processingError("Not implemented"))
    }

    public func getTransactionReceipt(_ txhash: String) -> Result<TransactionReceipt, NervosError> {
        return Result.failure(NervosError.processingError("Not implemented"))
    }

    public func getLogs() -> Result<BigUInt, NervosError> {
        /// TODO: parameters
        return Result.failure(NervosError.processingError("Not implemented"))
    }

    func call(_ transaction: EthereumTransaction, options: NervosOptions, onBlock: String = "latest") -> Result<Data, NervosError> {
        return Result.failure(NervosError.processingError("Not implemented"))
    }

    public func getTransaction(_ txhash: Data) -> Result<TransactionDetails, NervosError> {
        return Result.failure(NervosError.processingError("Not implemented"))
    }

    public func getTransaction(_ txhash: String) -> Result<TransactionDetails, NervosError> {
        return Result.failure(NervosError.processingError("Not implemented"))
    }

    public func getTransactionCount(address: EthereumAddress, onBlock: String = "latest") -> Result<BigUInt, NervosError> {
        return Result.failure(NervosError.processingError("Not implemented"))
    }

    public func getCode(address: String, onBlock: String = "latest") -> Result<Data, NervosError> {
        return Result.failure(NervosError.processingError("Not implemented"))
    }

    public func getAbi(address: String, onBlock: String = "latest") -> Result<Data, NervosError> {
        return Result.failure(NervosError.processingError("Not implemented"))
    }

    public func getBalance(address: EthereumAddress, onBlock: String = "latest") -> Result<BigUInt, NervosError> {
        return Result.failure(NervosError.processingError("Not implemented"))
    }

    public func newFilter() -> Result<BigUInt, NervosError> {
        /// TODO: parameters
        return Result.failure(NervosError.processingError("Not implemented"))
    }

    public func newBlockFilter() -> Result<BigUInt, NervosError> {
        /// TODO: parameters
        return Result.failure(NervosError.processingError("Not implemented"))
    }

    public func uninstallFilter() -> Result<BigUInt, NervosError> {
        /// TODO: parameters
        return Result.failure(NervosError.processingError("Not implemented"))
    }

    public func getFilterChanges() -> Result<BigUInt, NervosError> {
        /// TODO: parameters
        return Result.failure(NervosError.processingError("Not implemented"))
    }

    public func getFilterLogs() -> Result<BigUInt, NervosError> {
        /// TODO: parameters
        return Result.failure(NervosError.processingError("Not implemented"))
    }

    public func getTransactionProof(_ transactionHash: String) -> Result<Data, NervosError> {
        return Result.failure(NervosError.processingError("Not implemented"))
    }

    public func getTransactionProof(_ transactionHash: Data) -> Result<Data, NervosError> {
        return Result.failure(NervosError.processingError("Not implemented"))
    }

    public func getMetaData(_ blockNumber: BigUInt) -> Result<MetaData, NervosError> {
        return Result.failure(NervosError.processingError("Not implemented"))
    }

    public func getMetaData(_ blockNumber: String) -> Result<MetaData, NervosError> {
        return Result.failure(NervosError.processingError("Not implemented"))
    }

    public func getBlockHeader(_ blockNumber: String) -> Result<MetaData, NervosError> {
        return Result.failure(NervosError.processingError("Not implemented"))
    }

    public func getStateProof() -> Result<BigUInt, NervosError> {
        /// TODO: parameters
        return Result.failure(NervosError.processingError("Not implemented"))
    }
}
