//
//  AppChain+API.swift
//  Nervos
//
//  Created by Yate Fulham on 2018/08/20.
//  Copyright © 2018 Cryptape. All rights reserved.
//

import Foundation
import BigInt
import Result

// swiftlint:disable file_length

// MARK: - API helpers
private extension AppChain {
    func handle<T>(_ error: Error) -> Result<T, NervosError> {
        if let err = error as? NervosError {
            return Result.failure(err)
        }
        return Result.failure(NervosError.generalError(error))
    }
}

// MARK: - API
public extension AppChain {
    /// Get the number of AppChain peers currently connected to the client.
    ///
    /// - Returns: Peer count.
    func peerCount() -> Result<BigUInt, NervosError> {
        do {
            let result = try peerCountPromise().wait()
            return Result(result)
        } catch {
            return handle(error)
        }
    }

    /// Get the number of most recent block.
    ///
    /// - Returns: Current block height.
    func blockNumber() -> Result<UInt64, NervosError> {
        do {
            let result = try blockNumberPromise().wait()
            return Result(UInt64(result)) // `blockNumber` returns BigUInt but is cast down to uint64
        } catch {
            return handle(error)
        }
    }

    /// Send signed transaction to AppChain.
    ///
    /// - Parameter signedTx: Signed transaction data.
    ///
    /// - Returns: Transaction sending result.
    func sendRawTransaction(signedTx: Data) -> Result<TransactionSendingResult, NervosError> {
        return sendRawTransaction(signedTx: signedTx.toHexString().addHexPrefix())
    }

    /// Send signed transaction to AppChain.
    ///
    /// - Parameter signedTx: Signed transaction hex string.
    ///
    /// - Returns: Transaction sending result.
    func sendRawTransaction(signedTx: String) -> Result<TransactionSendingResult, NervosError> {
        do {
            let result = try sendRawTransactionPromise(signedTx: signedTx).wait()
            return Result(result)
        } catch {
            return handle(error)
        }
    }

    /// Get a block by hash.
    ///
    /// - Parameters:
    ///     - hash: The block hash data.
    ///     - fullTransactions: Whether to include transactions in the block object.
    ///
    /// - Returns: The block object matching the hash.
    func getBlockByHash(hash: Data, fullTransactions: Bool = false) -> Result<Block, NervosError> {
        return getBlockByHash(hash: hash.toHexString().addHexPrefix(), fullTransactions: fullTransactions)
    }

    /// Get a block by hash.
    ///
    /// - Parameters:
    ///     - hash: The block hash hex string.
    ///     - fullTransactions: Whether to include transactions in the block object.
    ///
    /// - Returns: The block object matching the hash.
    func getBlockByHash(hash: String, fullTransactions: Bool = false) -> Result<Block, NervosError> {
        do {
            let result = try getBlockByHashPromise(hash: hash.addHexPrefix(), fullTransactions: fullTransactions).wait()
            return Result(result)
        } catch {
            return handle(error)
        }
    }

    /// Get a block by number.
    ///
    /// - Parameters:
    ///     - number: The block number.
    ///     - fullTransactions: Whether to include transactions in the block object.
    ///
    /// - Returns: The block object matching the number.
    func getBlockByNumber(number: UInt64, fullTransactions: Bool = false) -> Result<Block, NervosError> {
        return getBlockByNumber(number: number.toHexString().addHexPrefix(), fullTransactions: fullTransactions)
    }

    /// Get a block by number.
    ///
    /// - Parameters:
    ///     - number: The block number.
    ///     - fullTransactions: Whether to include transactions in the block object.
    ///
    /// - Returns: The block object matching the number.
    func getBlockByNumber(number: BigUInt, fullTransactions: Bool = false) -> Result<Block, NervosError> {
        return getBlockByNumber(number: number.toHexString().addHexPrefix(), fullTransactions: fullTransactions)
    }

    /// Get a block by number.
    ///
    /// - Parameters:
    ///     - number: The block number hex string.
    ///     - fullTransactions: Whether to include transactions in the block object.
    ///
    /// - Returns: The block object matching the number.
    func getBlockByNumber(number: String, fullTransactions: Bool = false) -> Result<Block, NervosError> {
        do {
            let result = try getBlockByNumberPromise(number: number.addHexPrefix(), fullTransactions: fullTransactions).wait()
            return Result(result)
        } catch {
            return handle(error)
        }
    }

    /// Get the receipt of a transaction by transaction hash.
    ///
    /// - Parameter txhash: transaction hash data.
    ///
    /// - Returns: The receipt of transaction matching the txhash.
    func getTransactionReceipt(txhash: Data) -> Result<TransactionReceipt, NervosError> {
        return getTransactionReceipt(txhash: txhash.toHexString().addHexPrefix())
    }

    /// Get the receipt of a transaction by transaction hash.
    ///
    /// - Parameter txhash: transaction hash hex string.
    ///
    /// - Returns: The receipt of transaction matching the txhash.
    func getTransactionReceipt(txhash: String) -> Result<TransactionReceipt, NervosError> {
        do {
            let result = try getTransactionReceiptPromise(txhash: txhash.addHexPrefix()).wait()
            return Result(result)
        } catch {
            return handle(error)
        }
    }

    /// Get all logs matching a given filter object.
    ///
    /// - Parameter filter: The filter object.
    ///
    /// - Returns: An array of all logs matching the filter.
    func getLogs(filter: Filter) -> Result<[EventLog], NervosError> {
        do {
            let result = try getLogsPromise(filter: filter).wait()
            return Result(result)
        } catch {
            return handle(error)
        }
    }

    /// Execute a new call immediately on a contract.
    ///
    /// - Parameters:
    ///    - request: A call request.
    ///    - blockNumber: A block number
    ///
    /// - Returns: The transaction hash.
    func call(request: CallRequest, blockNumber: String = "latest") -> Result<String, NervosError> {
        do {
            let result = try callPromise(request: request, blockNumber: blockNumber).wait()
            return Result(result)
        } catch {
            return handle(error)
        }
    }

    /// Get a transaction for a given hash.
    ///
    /// - Parameter txhash: The transaction hash data.
    ///
    /// - Returns: A transaction details object.
    func getTransaction(txhash: Data) -> Result<TransactionDetails, NervosError> {
        return getTransaction(txhash: txhash.toHexString().addHexPrefix())
    }

    /// Get a transaction for a given hash.
    ///
    /// - Parameter txhash: The transaction hash hex string.
    ///
    /// - Returns: A transaction details object.
    func getTransaction(txhash: String) -> Result<TransactionDetails, NervosError> {
        do {
            let result = try getTransactionPromise(txhash: txhash.addHexPrefix()).wait()
            return Result(result)
        } catch {
            return handle(error)
        }
    }

    /// Get the number of transactions sent from an address.
    ///
    /// - Parameters:
    ///    - address: An address to check for transaction count for.
    ///    - blockNumber: A block number.
    ///
    /// - Returns: The number of transactions.
    func getTransactionCount(address: Address, blockNumber: String = "latest") -> Result<BigUInt, NervosError> {
        return getTransactionCount(address: address.address.lowercased(), blockNumber: blockNumber)
    }

    /// Get the number of transactions sent from an address.
    ///
    /// - Parameters:
    ///    - address: An address to check for transaction count for.
    ///    - blockNumber: A block number.
    ///
    /// - Returns: The number of transactions.
    func getTransactionCount(address: String, blockNumber: String = "latest") -> Result<BigUInt, NervosError> {
        do {
            let result = try getTransactionCountlPromise(address: address.lowercased().addHexPrefix(), blockNumber: blockNumber).wait()
            return Result(result)
        } catch {
            return handle(error)
        }
    }

    /// Get code at a given address.
    ///
    /// - Parameters:
    ///    - address: An address of the code.
    ///    - blockNumber: A block number.
    ///
    /// - Returns: The code at the given address.
    func getCode(address: Address, blockNumber: String = "latest") -> Result<String, NervosError> {
        return getCode(address: address.address.lowercased(), blockNumber: blockNumber)
    }

    /// Get code at a given address.
    ///
    /// - Parameters:
    ///    - address: An address of the code.
    ///    - blockNumber: A block number.
    ///
    /// - Returns: The code at the given address.
    func getCode(address: String, blockNumber: String = "latest") -> Result<String, NervosError> {
        do {
            let result = try getCodePromise(address: address.lowercased().addHexPrefix(), blockNumber: blockNumber).wait()
            return Result(result)
        } catch {
            return handle(error)
        }
    }

    /// Get ABI at a given address.
    ///
    /// - Parameters:
    ///    - address: An address of the ABI.
    ///    - blockNumber: A block number.
    ///
    /// - Returns: The ABI at the given address.
    func getAbi(address: Address, blockNumber: String = "latest") -> Result<String, NervosError> {
        return getAbi(address: address.address.lowercased(), blockNumber: blockNumber)
    }

    /// Get ABI at a given address.
    ///
    /// - Parameters:
    ///    - address: An address of the ABI.
    ///    - blockNumber: A block number.
    ///
    /// - Returns: The ABI at the given address.
    func getAbi(address: String, blockNumber: String = "latest") -> Result<String, NervosError> {
        do {
            let result = try getAbiPromise(address: address.lowercased().addHexPrefix(), blockNumber: blockNumber).wait()
            return Result(result)
        } catch {
            return handle(error)
        }
    }

    /// Get the balance of the account of given address.
    ///
    /// - Parameters:
    ///    - address: An address.
    ///    - blockNumber: A block number.
    ///
    /// - Returns: The balance of the account of the give address.
    func getBalance(address: Address, blockNumber: String = "latest") -> Result<BigUInt, NervosError> {
        return getBalance(address: address.address.lowercased(), blockNumber: blockNumber)
    }

    /// Get the balance of the account of given address.
    ///
    /// - Parameters:
    ///    - address: An address.
    ///    - blockNumber: A block number.
    ///
    /// - Returns: The balance of the account of the give address.
    func getBalance(address: String, blockNumber: String = "latest") -> Result<BigUInt, NervosError> {
        do {
            let result = try getBalancePromise(address: address.lowercased().addHexPrefix(), blockNumber: blockNumber).wait()
            return Result(result)
        } catch {
            return handle(error)
        }
    }

    /// Create a new filter object.
    ///
    /// - Parameter filter: The filter option object.
    ///
    /// - Returns: ID of the new filter.
    func newFilter(filter: Filter) -> Result<BigUInt, NervosError> {
        do {
            let result = try newFilterPromise(filter: filter).wait()
            return Result(result)
        } catch {
            return handle(error)
        }
    }

    /// Create a new block filter object.
    ///
    /// - Parameter filter: The filter option object.
    ///
    /// - Returns: ID of the new block filter.
    func newBlockFilter() -> Result<BigUInt, NervosError> {
        do {
            let result = try newBlockFilterPromise().wait()
            return Result(result)
        } catch {
            return handle(error)
        }
    }

    /// Uninstall a filter. Should always be called when watch is no longer needed.
    /// Additonally Filters timeout when they aren't requested with getFilterChanges for a period of time.
    ///
    /// - Parameter filterID: ID of the filter to uninstall.
    ///
    /// - Returns: True if the filter was successfully uninstalled, otherwise false.
    func uninstallFilter(filterID: BigUInt) -> Result<Bool, NervosError> {
        do {
            let result = try uninstallFilterPromise(filterID: filterID).wait()
            return Result(result)
        } catch {
            return handle(error)
        }
    }

    /// Get an array of logs which occurred since last poll.
    ///
    /// - Parameter filterID: ID of the filter to get changes from.
    ///
    /// - Returns: An array of logs which occurred since last poll.
    func getFilterChanges(filterID: BigUInt) -> Result<[EventLog], NervosError> {
        do {
            let result = try getFilterChangesPromise(filterID: filterID).wait()
            return Result(result)
        } catch {
            return handle(error)
        }
    }

    /// Get an array of all logs matching filter with given id.
    ///
    /// - Parameter filterID: ID of the filter to get logs from.
    ///
    /// - Returns: An array of logs matching the given filter id.
    func getFilterLogs(filterID: BigUInt) -> Result<[EventLog], NervosError> {
        do {
            let result = try getFilterLogsPromise(filterID: filterID).wait()
            return Result(result)
        } catch {
            return handle(error)
        }
    }

    /// Get transaction proof by a given transaction hash.
    ///
    /// - Parameter txhash: The transaction hash data.
    ///
    /// - Returns: A proof include transaction, receipt, receipt merkle tree proof, block header.
    ///     There will be a tool to verify the proof and extract some info.
    func getTransactionProof(txhash: Data) -> Result<String, NervosError> {
        return getTransactionProof(txhash: txhash.toHexString())
    }

    /// Get transaction proof by a given transaction hash.
    ///
    /// - Parameter txhash: The transaction hash.
    ///
    /// - Returns: A proof include transaction, receipt, receipt merkle tree proof, block header.
    ///     There will be a tool to verify the proof and extract some info.
    func getTransactionProof(txhash: String) -> Result<String, NervosError> {
        do {
            let result = try getTransactionProofPromise(txhash: txhash.addHexPrefix()).wait()
            return Result(result)
        } catch {
            return handle(error)
        }
    }

    /// Get AppChain metadata by a given block height.
    ///
    /// - Parameter blockNumber: The block height.
    ///
    /// - Returns: Metadata of the given block height.
    func getMetaData(blockNumber: BigUInt) -> Result<MetaData, NervosError> {
        return getMetaData(blockNumber: blockNumber.toHexString())
    }

    /// Get AppChain metadata by a given block height.
    ///
    /// - Parameter blockNumber: The block height, hex string integer or "latest".
    ///
    /// - Returns: Metadata of given block height.
    func getMetaData(blockNumber: String = "latest") -> Result<MetaData, NervosError> {
        do {
            let result = try getMetaDataPromise(blockNumber: blockNumber).wait()
            return Result(result)
        } catch {
            return handle(error)
        }
    }

    /// Get block header by a given block height.
    /// Note: Require 0.18.
    ///
    /// - Parameter blockNumber: The block height.
    ///
    /// - Returns: block header of the given block height.
    func getBlockHeader(blockNumber: UInt64) -> Result<String, NervosError> {
        return getBlockHeader(blockNumber: blockNumber.toHexString().addHexPrefix())
    }

    /// Get block header by a given block height.
    /// Note: Require 0.18.
    ///
    /// - Parameter blockNumber: The block height, hex string integer or "latest".
    ///
    /// - Returns: block header of the given block height.
    func getBlockHeader(blockNumber: String = "latest") -> Result<String, NervosError> {
        do {
            let result = try getBlockHeaderPromise(blockNumber: blockNumber).wait()
            return Result(result)
        } catch {
            return handle(error)
        }
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
    func getStateProof(address: Address, key: String, blockNumber: String = "latest") -> Result<String, NervosError> {
        return getStateProof(address: address.address.lowercased(), key: key, blockNumber: blockNumber)
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
    func getStateProof(address: String, key: String, blockNumber: String = "latest") -> Result<String, NervosError> {
        do {
            let result = try getStateProofPromise(address: address.lowercased().addHexPrefix(), key: key, blockNumber: blockNumber).wait()
            return Result(result)
        } catch {
            return handle(error)
        }
    }
}
