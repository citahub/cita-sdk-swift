//
//  AppChain+Promises.swift
//  Nervos
//
//  Created by Yate Fulham on 2018/08/13.
//  Copyright © 2018 Cryptape. All rights reserved.
//

import Foundation
import BigInt
import PromiseKit

// MARK: - Promise helpers
extension AppChain {
    func responseError(_ response: Response) -> NervosError {
        if let error = response.error {
            return NervosError.nodeError(error.message)
        }
        return NervosError.nodeError("Invalid value from Nervos node")
    }

    func apiPromise<T>(_ method: Method, parameters: [Encodable]) -> Promise<T> {
        let request = RequestFabric.prepareRequest(method, parameters: parameters)
        return nervos!.dispatch(request).map(on: nervos!.requestDispatcher.queue) { response in
            guard let value: T = response.getValue() else {
                throw self.responseError(response)
            }
            return value
        }

    }
}

// MARK: - API Promises
extension AppChain {
    func peerCountPromise() -> Promise<BigUInt> {
        return apiPromise(.peerCount, parameters: [])
    }

    func blockNumberPromise() -> Promise<BigUInt> {
        return apiPromise(.blockNumber, parameters: [])
    }

    func sendRawTransactionPromise(signedData: String) -> Promise<String> {
        return apiPromise(.sendRawTransaction, parameters: [signedData])
    }

    func getBlockByHashPromise(hash: String, fullTransactions: Bool) -> Promise<Block> {
        return apiPromise(.getBlockByHash, parameters: [hash, fullTransactions])
    }

    func getBlockByNumberPromise(number: String, fullTransactions: Bool) -> Promise<Block> {
        return apiPromise(.getBlockByNumber, parameters: [number, fullTransactions])
    }

    func getTransactionReceiptPromise(txhash: String) -> Promise<TransactionReceipt> {
        return apiPromise(.getTransactionReceipt, parameters: [txhash])
    }

    /*
    func getLogsPromise(_ filter: [String: Any]) -> Promise<[Any]> {
        return apiPromise(.getLogs, parameters: [filter])
    }*/

    /*
     func callPromise() -> Promise<T> {
     return apiPromise(., parameters: [])
     } */

    func getTransactionPromise(txhash: String) -> Promise<TransactionDetails> {
        return apiPromise(.getTransaction, parameters: [txhash])
    }

    func getTransactionCountlPromise(address: String, blockNumber: String) -> Promise<BigUInt> {
        return apiPromise(.getTransactionCount, parameters: [address.lowercased(), blockNumber])
    }

    func getCodePromise(address: String, blockNumber: String) -> Promise<String> {
        return apiPromise(.getCode, parameters: [address.lowercased(), blockNumber])
    }

    func getAbiPromise(address: String, blockNumber: String) -> Promise<String> {
        return apiPromise(.getAbi, parameters: [address.lowercased(), blockNumber])
    }

     func getBalancePromise(address: String, blockNumber: String) -> Promise<BigUInt> {
        return apiPromise(.getBalance, parameters: [address.lowercased(), blockNumber])
     }

    /*
     func newFilterPromise() -> Promise<T> {
     return apiPromise(., parameters: [])
     } */

    /*
     func newBlockFilterPromise() -> Promise<T> {
     return apiPromise(., parameters: [])
     } */

    /*
     func uninstallFilterPromise() -> Promise<T> {
     return apiPromise(., parameters: [])
     } */

    /*
     func getFilterChangesPromise() -> Promise<T> {
     return apiPromise(., parameters: [])
     } */

    /*
     func getFilterLogsPromise() -> Promise<T> {
     return apiPromise(., parameters: [])
     } */

    func getTransactionProofPromise(txhash: String) -> Promise<String> {
        return apiPromise(.getTransactionProof, parameters: [txhash])
    }

    func getMetaDataPromise(blockNumber: String) -> Promise<MetaData> {
        return apiPromise(.getMetaData, parameters: [blockNumber])
    }

    func getBlockHeaderPromise(blockNumber: String) -> Promise<String> {
        return apiPromise(.getBlockHeader, parameters: [blockNumber])
    }

    func getStateProofPromise(address: String, key: String, blockNumber: String) -> Promise<String> {
     return apiPromise(.getStateProof, parameters: [address.lowercased(), key, blockNumber])
    }
}
