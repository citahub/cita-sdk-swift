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
    func peerCount() -> Result<BigUInt, NervosError> {
        do {
            let result = try peerCountPromise().wait()
            return Result(result)
        } catch {
            return handle(error)
        }
    }

    func blockNumber() -> Result<BigUInt, NervosError> {
        do {
            let result = try blockNumberPromise().wait()
            return Result(result)
        } catch {
            return handle(error)
        }
    }

    func sendRawTransaction(signedTx: Data) -> Result<TransactionSendingResult, NervosError> {
        return sendRawTransaction(signedTx: signedTx.toHexString().addHexPrefix())
    }

    func sendRawTransaction(signedTx: String) -> Result<TransactionSendingResult, NervosError> {
        do {
            let result = try sendRawTransactionPromise(signedTx: signedTx).wait()
            return Result(result)
        } catch {
            return handle(error)
        }
    }

    func getBlockByHash(hash: Data, fullTransactions: Bool = false) -> Result<Block, NervosError> {
        return getBlockByHash(hash: hash.toHexString().addHexPrefix(), fullTransactions: fullTransactions)
    }

    func getBlockByHash(hash: String, fullTransactions: Bool = false) -> Result<Block, NervosError> {
        do {
            let result = try getBlockByHashPromise(hash: hash, fullTransactions: fullTransactions).wait()
            return Result(result)
        } catch {
            return handle(error)
        }
    }

    func getBlockByNumber(number: UInt64, fullTransactions: Bool = false) -> Result<Block, NervosError> {
        return getBlockByNumber(number: number.toHexString().addHexPrefix(), fullTransactions: fullTransactions)
    }

    func getBlockByNumber(number: BigUInt, fullTransactions: Bool = false) -> Result<Block, NervosError> {
        return getBlockByNumber(number: number.toHexString().addHexPrefix(), fullTransactions: fullTransactions)
    }

    func getBlockByNumber(number: String, fullTransactions: Bool = false) -> Result<Block, NervosError> {
        do {
            let result = try getBlockByNumberPromise(number: number.addHexPrefix(), fullTransactions: fullTransactions).wait()
            return Result(result)
        } catch {
            return handle(error)
        }
    }

    func getTransactionReceipt(txhash: Data) -> Result<TransactionReceipt, NervosError> {
        return getTransactionReceipt(txhash: txhash.toHexString().addHexPrefix())
    }

    func getTransactionReceipt(txhash: String) -> Result<TransactionReceipt, NervosError> {
        do {
            let result = try getTransactionReceiptPromise(txhash: txhash).wait()
            return Result(result)
        } catch {
            return handle(error)
        }
    }

    func getLogs(filter: Filter) -> Result<[EventLog], NervosError> {
        do {
            let result = try getLogsPromise(filter: filter).wait()
            return Result(result)
        } catch {
            return handle(error)
        }
    }

    func call(request: CallRequest, blockNumber: String = "latest") -> Result<String, NervosError> {
        do {
            let result = try callPromise(request: request, blockNumber: blockNumber).wait()
            return Result(result)
        } catch {
            return handle(error)
        }
    }

    func getTransaction(txhash: Data) -> Result<TransactionDetails, NervosError> {
        return getTransaction(txhash: txhash.toHexString().addHexPrefix())
    }

    func getTransaction(txhash: String) -> Result<TransactionDetails, NervosError> {
        do {
            let result = try getTransactionPromise(txhash: txhash).wait()
            return Result(result)
        } catch {
            return handle(error)
        }
    }

    func getTransactionCount(address: Address, blockNumber: String = "latest") -> Result<BigUInt, NervosError> {
        return getTransactionCount(address: address.address, blockNumber: blockNumber)
    }

    func getTransactionCount(address: String, blockNumber: String = "latest") -> Result<BigUInt, NervosError> {
        do {
            let result = try getTransactionCountlPromise(address: address, blockNumber: blockNumber).wait()
            return Result(result)
        } catch {
            return handle(error)
        }
    }

    func getCode(address: Address, blockNumber: String = "latest") -> Result<String, NervosError> {
        return getCode(address: address.address, blockNumber: blockNumber)
    }

    func getCode(address: String, blockNumber: String = "latest") -> Result<String, NervosError> {
        do {
            let result = try getCodePromise(address: address, blockNumber: blockNumber).wait()
            return Result(result)
        } catch {
            return handle(error)
        }
    }

    func getAbi(address: Address, blockNumber: String = "latest") -> Result<String, NervosError> {
        return getAbi(address: address.address, blockNumber: blockNumber)
    }

    func getAbi(address: String, blockNumber: String = "latest") -> Result<String, NervosError> {
        do {
            let result = try getAbiPromise(address: address, blockNumber: blockNumber).wait()
            return Result(result)
        } catch {
            return handle(error)
        }
    }

    func getBalance(address: Address, blockNumber: String = "latest") -> Result<BigUInt, NervosError> {
        return getBalance(address: address.address, blockNumber: blockNumber)
    }

    func getBalance(address: String, blockNumber: String = "latest") -> Result<BigUInt, NervosError> {
        do {
            let result = try getBalancePromise(address: address, blockNumber: blockNumber).wait()
            return Result(result)
        } catch {
            return handle(error)
        }
    }

    func newFilter(filter: Filter) -> Result<BigUInt, NervosError> {
        do {
            let result = try newFilterPromise(filter: filter).wait()
            return Result(result)
        } catch {
            return handle(error)
        }
    }

    func newBlockFilter() -> Result<BigUInt, NervosError> {
        do {
            let result = try newBlockFilterPromise().wait()
            return Result(result)
        } catch {
            return handle(error)
        }
    }

    func uninstallFilter(filterID: BigUInt) -> Result<Bool, NervosError> {
        do {
            let result = try uninstallFilterPromise(filterID: filterID).wait()
            return Result(result)
        } catch {
            return handle(error)
        }
    }

    func getFilterChanges(filterID: BigUInt) -> Result<[EventLog], NervosError> {
        do {
            let result = try getFilterChangesPromise(filterID: filterID).wait()
            return Result(result)
        } catch {
            return handle(error)
        }
    }

    func getFilterLogs(filterID: BigUInt) -> Result<[EventLog], NervosError> {
        do {
            let result = try getFilterLogsPromise(filterID: filterID).wait()
            return Result(result)
        } catch {
            return handle(error)
        }
    }

    func getTransactionProof(txhash: Data) -> Result<String, NervosError> {
        return getTransactionProof(txhash: txhash.toHexString().addHexPrefix())
    }

    func getTransactionProof(txhash: String) -> Result<String, NervosError> {
        do {
            let result = try getTransactionProofPromise(txhash: txhash).wait()
            return Result(result)
        } catch {
            return handle(error)
        }
    }

   func getMetaData(_ blockNumber: BigUInt) -> Result<MetaData, NervosError> {
        return getMetaData(blockNumber: blockNumber.toHexString().addHexPrefix())
    }

    func getMetaData(blockNumber: String = "latest") -> Result<MetaData, NervosError> {
        do {
            let result = try getMetaDataPromise(blockNumber: blockNumber).wait()
            return Result(result)
        } catch {
            return handle(error)
        }
    }

    func getBlockHeader(blockNumber: BigUInt) -> Result<String, NervosError> {
        return getBlockHeader(blockNumber: blockNumber.toHexString().addHexPrefix())
    }

    func getBlockHeader(blockNumber: String = "latest") -> Result<String, NervosError> {
        // TODO: verify if this works
        do {
            let result = try getBlockHeaderPromise(blockNumber: blockNumber).wait()
            return Result(result)
        } catch {
            return handle(error)
        }
    }

    func getStateProof(address: Address, key: String, blockNumber: String = "latest") -> Result<String, NervosError> {
        return getStateProof(address: address.address, key: key, blockNumber: blockNumber)
    }

    func getStateProof(address: String, key: String, blockNumber: String = "latest") -> Result<String, NervosError> {
        // TODO: verify if this works
        do {
            let result = try getStateProofPromise(address: address, key: key, blockNumber: blockNumber).wait()
            return Result(result)
        } catch {
            return handle(error)
        }
    }
}
