//
//  AppChain.swift
//  Nervos
//
//  Created by Yate Fulham on 2018/08/10.
//  Copyright © 2018 Cryptape. All rights reserved.
//

import Foundation
import BigInt
import Result

public class AppChain: NervosOptionsInheritable {
    var provider: NervosProvider
    weak var nervos: Nervos?

    public var options: NervosOptions {
        return nervos!.options
    }

    public init(provider: NervosProvider, nervos: Nervos) {
        self.provider = provider
        self.nervos = nervos
    }
}

// MARK: - API helpers
extension AppChain {
    func handle<T>(_ error: Error) -> Result<T, NervosError> {
        if let err = error as? NervosError {
            return Result.failure(err)
        }
        return Result.failure(NervosError.generalError(error))
    }
}

// MARK: - API
extension AppChain {
    public func peerCount() -> Result<BigUInt, NervosError> {
        do {
            let result = try peerCountPromise().wait()
            return Result(result)
        } catch {
            return handle(error)
        }
    }

    public func blockNumber() -> Result<BigUInt, NervosError> {
        do {
            let result = try blockNumberPromise().wait()
            return Result(result)
        } catch {
            return handle(error)
        }
    }

    public func sendRawTransaction(signedTx: Data) -> Result<TransactionSendingResult, NervosError> {
        return sendRawTransaction(signedTx: signedTx.toHexString().addHexPrefix())
    }

    public func sendRawTransaction(signedTx: String) -> Result<TransactionSendingResult, NervosError> {
        do {
            let result = try sendRawTransactionPromise(signedTx: signedTx).wait()
            return Result(result)
        } catch {
            return handle(error)
        }
    }

    public func getBlockByHash(hash: Data, fullTransactions: Bool = false) -> Result<Block, NervosError> {
        return getBlockByHash(hash: hash.toHexString().addHexPrefix(), fullTransactions: fullTransactions)
    }

    public func getBlockByHash(hash: String, fullTransactions: Bool = false) -> Result<Block, NervosError> {
        do {
            let result = try getBlockByHashPromise(hash: hash, fullTransactions: fullTransactions).wait()
            return Result(result)
        } catch {
            return handle(error)
        }
    }

    public func getBlockByNumber(number: UInt64, fullTransactions: Bool = false) -> Result<Block, NervosError> {
        return getBlockByNumber(number: number.toHexString().addHexPrefix(), fullTransactions: fullTransactions)
    }

    public func getBlockByNumber(number: BigUInt, fullTransactions: Bool = false) -> Result<Block, NervosError> {
        return getBlockByNumber(number: number.toHexString().addHexPrefix(), fullTransactions: fullTransactions)
    }

    public func getBlockByNumber(number: String, fullTransactions: Bool = false) -> Result<Block, NervosError> {
        do {
            let result = try getBlockByNumberPromise(number: number.addHexPrefix(), fullTransactions: fullTransactions).wait()
            return Result(result)
        } catch {
            return handle(error)
        }
    }

    public func getTransactionReceipt(txhash: Data) -> Result<TransactionReceipt, NervosError> {
        return getTransactionReceipt(txhash: txhash.toHexString().addHexPrefix())
    }

    public func getTransactionReceipt(txhash: String) -> Result<TransactionReceipt, NervosError> {
        do {
            let result = try getTransactionReceiptPromise(txhash: txhash).wait()
            return Result(result)
        } catch {
            return handle(error)
        }
    }

    public func getLogs(filter: EventFilterParameters) -> Result<[EventLog], NervosError> {
        do {
            let result = try getLogsPromise(filter: filter).wait()
            return Result(result)
        } catch {
            return handle(error)
        }
    }

    func call(request: CallRequestParameters, blockNumber: String = "latest") -> Result<String, NervosError> {
        do {
            let result = try callPromise(request: request, blockNumber: blockNumber).wait()
            return Result(result)
        } catch {
            return handle(error)
        }
    }

    public func getTransaction(txhash: Data) -> Result<TransactionDetails, NervosError> {
        return getTransaction(txhash: txhash.toHexString().addHexPrefix())
    }

    public func getTransaction(txhash: String) -> Result<TransactionDetails, NervosError> {
        do {
            let result = try getTransactionPromise(txhash: txhash).wait()
            return Result(result)
        } catch {
            return handle(error)
        }
    }

    public func getTransactionCount(address: Address, blockNumber: String = "latest") -> Result<BigUInt, NervosError> {
        return getTransactionCount(address: address.address, blockNumber: blockNumber)
    }

    public func getTransactionCount(address: String, blockNumber: String = "latest") -> Result<BigUInt, NervosError> {
        do {
            let result = try getTransactionCountlPromise(address: address, blockNumber: blockNumber).wait()
            return Result(result)
        } catch {
            return handle(error)
        }
    }

    public func getCode(address: Address, blockNumber: String = "latest") -> Result<String, NervosError> {
        return getCode(address: address.address, blockNumber: blockNumber)
    }

    public func getCode(address: String, blockNumber: String = "latest") -> Result<String, NervosError> {
        do {
            let result = try getCodePromise(address: address, blockNumber: blockNumber).wait()
            return Result(result)
        } catch {
            return handle(error)
        }
    }

    public func getAbi(address: Address, blockNumber: String = "latest") -> Result<String, NervosError> {
        return getAbi(address: address.address, blockNumber: blockNumber)
    }

    public func getAbi(address: String, blockNumber: String = "latest") -> Result<String, NervosError> {
        do {
            let result = try getAbiPromise(address: address, blockNumber: blockNumber).wait()
            return Result(result)
        } catch {
            return handle(error)
        }
    }

    public func getBalance(address: Address, blockNumber: String = "latest") -> Result<BigUInt, NervosError> {
        return getBalance(address: address.address, blockNumber: blockNumber)
    }

    public func getBalance(address: String, blockNumber: String = "latest") -> Result<BigUInt, NervosError> {
        do {
            let result = try getBalancePromise(address: address, blockNumber: blockNumber).wait()
            return Result(result)
        } catch {
            return handle(error)
        }
    }

    // TODO: implement filters.

    public func newFilter(filter: [String: Any]) -> Result<BigUInt, NervosError> {
        return Result.failure(NervosError.processingError("Not implemented"))
    }

    public func newBlockFilter() -> Result<BigUInt, NervosError> {
        return Result.failure(NervosError.processingError("Not implemented"))
    }

    public func uninstallFilter(filterID: String) -> Result<Bool, NervosError> {
        return Result.failure(NervosError.processingError("Not implemented"))
    }

    public func getFilterChanges(filterID: String) -> Result<[Any], NervosError> {
        return Result.failure(NervosError.processingError("Not implemented"))
    }

    public func getFilterLogs(filterID: String) -> Result<[Any], NervosError> {
        return Result.failure(NervosError.processingError("Not implemented"))
    }

    public func getTransactionProof(txhash: Data) -> Result<String, NervosError> {
        return getTransactionProof(txhash: txhash.toHexString().addHexPrefix())
    }

    public func getTransactionProof(txhash: String) -> Result<String, NervosError> {
        do {
            let result = try getTransactionProofPromise(txhash: txhash).wait()
            return Result(result)
        } catch {
            return handle(error)
        }
    }

    public func getMetaData(_ blockNumber: BigUInt) -> Result<MetaData, NervosError> {
        return getMetaData(blockNumber: blockNumber.toHexString().addHexPrefix())
    }

    public func getMetaData(blockNumber: String = "latest") -> Result<MetaData, NervosError> {
        do {
            let result = try getMetaDataPromise(blockNumber: blockNumber).wait()
            return Result(result)
        } catch {
            return handle(error)
        }
    }

    public func getBlockHeader(blockNumber: BigUInt) -> Result<String, NervosError> {
        return getBlockHeader(blockNumber: blockNumber.toHexString().addHexPrefix())
    }

    public func getBlockHeader(blockNumber: String = "latest") -> Result<String, NervosError> {
        // TODO: verify if this works
        do {
            let result = try getBlockHeaderPromise(blockNumber: blockNumber).wait()
            return Result(result)
        } catch {
            return handle(error)
        }
    }

    public func getStateProof(address: Address, key: String, blockNumber: String = "latest") -> Result<String, NervosError> {
        return getStateProof(address: address.address, key: key, blockNumber: blockNumber)
    }

    public func getStateProof(address: String, key: String, blockNumber: String = "latest") -> Result<String, NervosError> {
        // TODO: verify if this works
        do {
            let result = try getStateProofPromise(address: address, key: key, blockNumber: blockNumber).wait()
            return Result(result)
        } catch {
            return handle(error)
        }
    }
}
