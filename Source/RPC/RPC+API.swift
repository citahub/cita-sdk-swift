//
//  RPC+API.swift
//  AppChain
//
//  Created by Yate Fulham on 2018/08/20.
//  Copyright © 2018 Cryptape. All rights reserved.
//

import Foundation
import BigInt

// MARK: - API

public extension RPC {
    /// Get the number of AppChain peers currently connected to the client.
    ///
    /// - Returns: Peer count.
    func peerCount() throws -> BigUInt {
        return try peerCountPromise().wait()
    }

    /// Get the number of most recent block.
    ///
    /// - Returns: Current block height.
    func blockNumber() throws -> UInt64 {
        return UInt64(try blockNumberPromise().wait())  // `blockNumber` returns BigUInt but is cast down to uint64
    }

    /// Send signed transaction to AppChain.
    ///
    /// - Parameter signedTx: Signed transaction data.
    ///
    /// - Returns: Transaction hash.
    func sendRawTransaction(signedTx: Data) throws -> String {
        return try sendRawTransaction(signedTx: signedTx.toHexString().addHexPrefix())
    }

    /// Send signed transaction to AppChain.
    ///
    /// - Parameter signedTx: Signed transaction hex string.
    ///
    /// - Returns: Transaction hash.
    func sendRawTransaction(signedTx: String) throws -> String {
        return try sendRawTransactionPromise(signedTx: signedTx).wait().hash.toHexString().addHexPrefix()
    }

    /// Get a block by hash.
    ///
    /// - Parameters:
    ///     - hash: The block hash data.
    ///     - fullTransactions: Whether to include transactions in the block object.
    ///
    /// - Returns: The block object matching the hash.
    func getBlockByHash(hash: Data, fullTransactions: Bool = false) throws -> Block {
        return try getBlockByHash(hash: hash.toHexString().addHexPrefix(), fullTransactions: fullTransactions)
    }

    /// Get a block by hash.
    ///
    /// - Parameters:
    ///     - hash: The block hash hex string.
    ///     - fullTransactions: Whether to include transactions in the block object.
    ///
    /// - Returns: The block object matching the hash.
    func getBlockByHash(hash: String, fullTransactions: Bool = false) throws -> Block {
        return try getBlockByHashPromise(hash: hash.addHexPrefix(), fullTransactions: fullTransactions).wait()
    }

    /// Get a block by number.
    ///
    /// - Parameters:
    ///     - number: The block number.
    ///     - fullTransactions: Whether to include transactions in the block object.
    ///
    /// - Returns: The block object matching the number.
    func getBlockByNumber(number: UInt64, fullTransactions: Bool = false) throws -> Block {
        return try getBlockByNumber(number: number.toHexString().addHexPrefix(), fullTransactions: fullTransactions)
    }

    /// Get a block by number.
    ///
    /// - Parameters:
    ///     - number: The block number.
    ///     - fullTransactions: Whether to include transactions in the block object.
    ///
    /// - Returns: The block object matching the number.
    func getBlockByNumber(number: BigUInt, fullTransactions: Bool = false) throws -> Block {
        return try getBlockByNumber(number: number.toHexString().addHexPrefix(), fullTransactions: fullTransactions)
    }

    /// Get a block by number.
    ///
    /// - Parameters:
    ///     - number: The block number hex string.
    ///     - fullTransactions: Whether to include transactions in the block object.
    ///
    /// - Returns: The block object matching the number.
    func getBlockByNumber(number: String, fullTransactions: Bool = false) throws -> Block {
        return try getBlockByNumberPromise(number: number.addHexPrefix(), fullTransactions: fullTransactions).wait()
    }

    /// Get the receipt of a transaction by transaction hash.
    ///
    /// - Parameter txhash: transaction hash data.
    ///
    /// - Returns: The receipt of transaction matching the txhash.
    func getTransactionReceipt(txhash: Data) throws -> TransactionReceipt {
        return try getTransactionReceipt(txhash: txhash.toHexString().addHexPrefix())
    }

    /// Get the receipt of a transaction by transaction hash.
    ///
    /// - Parameter txhash: transaction hash hex string.
    ///
    /// - Returns: The receipt of transaction matching the txhash.
    func getTransactionReceipt(txhash: String) throws -> TransactionReceipt {
        return try getTransactionReceiptPromise(txhash: txhash.addHexPrefix()).wait()
    }

    /// Get all logs matching a given filter object.
    ///
    /// - Parameter filter: The filter object.
    ///
    /// - Returns: An array of all logs matching the filter.
    func getLogs(filter: Filter) throws -> [EventLog] {
        return try getLogsPromise(filter: filter).wait()
    }

    /// Execute a new call immediately on a contract.
    ///
    /// - Parameters:
    ///    - request: A call request.
    ///    - blockNumber: A block number
    ///
    /// - Returns: The call result as hex string.
    func call(request: CallRequest, blockNumber: String = "latest") throws -> String {
        return try callPromise(request: request, blockNumber: blockNumber).wait()
    }

    /// Get a transaction for a given hash.
    ///
    /// - Parameter txhash: The transaction hash data.
    ///
    /// - Returns: A transaction details object.
    func getTransaction(txhash: Data) throws -> TransactionDetails {
        return try getTransaction(txhash: txhash.toHexString().addHexPrefix())
    }

    /// Get a transaction for a given hash.
    ///
    /// - Parameter txhash: The transaction hash hex string.
    ///
    /// - Returns: A transaction details object.
    func getTransaction(txhash: String) throws -> TransactionDetails {
        return try getTransactionPromise(txhash: txhash.addHexPrefix()).wait()
    }

    /// Get the number of transactions sent from an address.
    ///
    /// - Parameters:
    ///    - address: An address to check for transaction count for.
    ///    - blockNumber: A block number.
    ///
    /// - Returns: The number of transactions.
    func getTransactionCount(address: Address, blockNumber: String = "latest") throws -> BigUInt {
        return try getTransactionCount(address: address.address.lowercased(), blockNumber: blockNumber)
    }

    /// Get the number of transactions sent from an address.
    ///
    /// - Parameters:
    ///    - address: An address to check for transaction count for.
    ///    - blockNumber: A block number.
    ///
    /// - Returns: The number of transactions.
    func getTransactionCount(address: String, blockNumber: String = "latest") throws -> BigUInt {
        return try getTransactionCountlPromise(address: address.lowercased().addHexPrefix(), blockNumber: blockNumber).wait()
    }

    /// Get code at a given address.
    ///
    /// - Parameters:
    ///    - address: An address of the code.
    ///    - blockNumber: A block number.
    ///
    /// - Returns: The code at the given address.
    func getCode(address: Address, blockNumber: String = "latest") throws -> String {
        return try getCode(address: address.address.lowercased(), blockNumber: blockNumber)
    }

    /// Get code at a given address.
    ///
    /// - Parameters:
    ///    - address: An address of the code.
    ///    - blockNumber: A block number.
    ///
    /// - Returns: The code at the given address.
    func getCode(address: String, blockNumber: String = "latest") throws -> String {
        return try getCodePromise(address: address.lowercased().addHexPrefix(), blockNumber: blockNumber).wait()
    }

    /// Get ABI at a given address.
    ///
    /// - Parameters:
    ///    - address: An address of the ABI.
    ///    - blockNumber: A block number.
    ///
    /// - Returns: The ABI at the given address.
    func getAbi(address: Address, blockNumber: String = "latest") throws -> String {
        return try getAbi(address: address.address.lowercased(), blockNumber: blockNumber)
    }

    /// Get ABI at a given address.
    ///
    /// - Parameters:
    ///    - address: An address of the ABI.
    ///    - blockNumber: A block number.
    ///
    /// - Returns: The ABI at the given address.
    func getAbi(address: String, blockNumber: String = "latest") throws -> String {
        return try getAbiPromise(address: address.lowercased().addHexPrefix(), blockNumber: blockNumber).wait()
    }

    /// Get the balance of the account of given address.
    ///
    /// - Parameters:
    ///    - address: An address.
    ///    - blockNumber: A block number.
    ///
    /// - Returns: The balance of the account of the give address.
    func getBalance(address: Address, blockNumber: String = "latest") throws -> BigUInt {
        return try getBalance(address: address.address.lowercased(), blockNumber: blockNumber)
    }

    /// Get the balance of the account of given address.
    ///
    /// - Parameters:
    ///    - address: An address.
    ///    - blockNumber: A block number.
    ///
    /// - Returns: The balance of the account of the give address.
    func getBalance(address: String, blockNumber: String = "latest") throws -> BigUInt {
        return try getBalancePromise(address: address.lowercased().addHexPrefix(), blockNumber: blockNumber).wait()
    }

    /// Create a new filter object.
    ///
    /// - Parameter filter: The filter option object.
    ///
    /// - Returns: ID of the new filter.
    func newFilter(filter: Filter) throws -> BigUInt {
        return try newFilterPromise(filter: filter).wait()
    }

    /// Create a new block filter object.
    ///
    /// - Parameter filter: The filter option object.
    ///
    /// - Returns: ID of the new block filter.
    func newBlockFilter() throws -> BigUInt {
        return try newBlockFilterPromise().wait()
    }

    /// Uninstall a filter. Should always be called when watch is no longer needed.
    /// Additonally Filters timeout when they aren't requested with getFilterChanges for a period of time.
    ///
    /// - Parameter filterID: ID of the filter to uninstall.
    ///
    /// - Returns: True if the filter was successfully uninstalled, otherwise false.
    func uninstallFilter(filterID: BigUInt) throws -> Bool {
        return try uninstallFilterPromise(filterID: filterID).wait()
    }

    /// Get an array of logs which occurred since last poll.
    ///
    /// - Parameter filterID: ID of the filter to get changes from.
    ///
    /// - Returns: An array of logs which occurred since last poll.
    func getFilterChanges(filterID: BigUInt) throws -> [EventLog] {
        return try getFilterChangesPromise(filterID: filterID).wait()
    }

    /// Get an array of all logs matching filter with given id.
    ///
    /// - Parameter filterID: ID of the filter to get logs from.
    ///
    /// - Returns: An array of logs matching the given filter id.
    func getFilterLogs(filterID: BigUInt) throws -> [EventLog] {
        return try getFilterLogsPromise(filterID: filterID).wait()
    }

    /// Get transaction proof by a given transaction hash.
    ///
    /// - Parameter txhash: The transaction hash data.
    ///
    /// - Returns: A proof include transaction, receipt, receipt merkle tree proof, block header.
    ///     There will be a tool to verify the proof and extract some info.
    func getTransactionProof(txhash: Data) throws -> String {
        return try getTransactionProof(txhash: txhash.toHexString())
    }

    /// Get transaction proof by a given transaction hash.
    ///
    /// - Parameter txhash: The transaction hash.
    ///
    /// - Returns: A proof include transaction, receipt, receipt merkle tree proof, block header.
    ///     There will be a tool to verify the proof and extract some info.
    func getTransactionProof(txhash: String) throws -> String {
        return try getTransactionProofPromise(txhash: txhash.addHexPrefix()).wait()
    }

    /// Get AppChain metadata by a given block height.
    ///
    /// - Parameter blockNumber: The block height.
    ///
    /// - Returns: Metadata of the given block height.
    func getMetaData(blockNumber: BigUInt) throws -> MetaData {
        return try getMetaData(blockNumber: blockNumber.toHexString())
    }

    /// Get AppChain metadata by a given block height.
    ///
    /// - Parameter blockNumber: The block height, hex string integer or "latest".
    ///
    /// - Returns: Metadata of given block height.
    func getMetaData(blockNumber: String = "latest") throws -> MetaData {
        return try getMetaDataPromise(blockNumber: blockNumber).wait()
    }

    /// Get block header by a given block height.
    /// Note: Require 0.18.
    ///
    /// - Parameter blockNumber: The block height.
    ///
    /// - Returns: block header of the given block height.
    func getBlockHeader(blockNumber: UInt64) throws -> String {
        return try getBlockHeader(blockNumber: blockNumber.toHexString().addHexPrefix())
    }

    /// Get block header by a given block height.
    /// Note: Require 0.18.
    ///
    /// - Parameter blockNumber: The block height, hex string integer or "latest".
    ///
    /// - Returns: block header of the given block height.
    func getBlockHeader(blockNumber: String = "latest") throws -> String {
        return try getBlockHeaderPromise(blockNumber: blockNumber).wait()
    }

    /// Get state proof of special value. Include address, account proof, key, value proof.
    /// Note: Require 0.18.
    ///
    /// - Parameters:
    ///    - address: An address.
    ///    - key: A key, position of the variable.
    ///    - blockNumber: The block number, hex string integer, or the string "latest", "earliest".
    ///
    /// - Returns: State proof of special value. Include address, account proof, key, value proof.
    func getStateProof(address: Address, key: String, blockNumber: String = "latest") throws -> String {
        return try getStateProof(address: address.address.lowercased(), key: key, blockNumber: blockNumber)
    }

    /// Get state proof of special value. Include address, account proof, key, value proof.
    /// Note: Require 0.18.
    ///
    /// - Parameters:
    ///    - address: An address.
    ///    - key: A key, position of the variable.
    ///    - blockNumber: The block number, hex string integer, or the string "latest", "earliest".
    ///
    /// - Returns: State proof of special value. Include address, account proof, key, value proof.
    func getStateProof(address: String, key: String, blockNumber: String = "latest") throws -> String {
        return try getStateProofPromise(address: address.lowercased().addHexPrefix(), key: key, blockNumber: blockNumber).wait()
    }
}
