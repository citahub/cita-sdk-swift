//
//  Method.swift
//  AppChain
//
//  Created by Yate Fulham on 2018/08/10.
//  Copyright © 2018 Cryptape. All rights reserved.
//

import Foundation

public enum Method: String, Encodable {
    case peerCount
    case blockNumber
    case sendRawTransaction
    case getBlockByHash
    case getBlockByNumber
    case getTransactionReceipt
    case getLogs
    case call
    case getTransaction
    case getTransactionCount
    case getCode
    case getAbi
    case getBalance
    case newFilter
    case newBlockFilter
    case uninstallFilter
    case getFilterChanges
    case getFilterLogs
    case getTransactionProof
    case getMetaData
    case getBlockHeader
    case getStateProof

    var requiredNumOfParameters: Int {
        let mapping: [Method: Int] = [
            .peerCount: 0,
            .blockNumber: 0,
            .sendRawTransaction: 1,
            .getBlockByHash: 2,
            .getBlockByNumber: 2,
            .getTransactionReceipt: 1,
            .getLogs: 1,
            .call: 2,
            .getTransaction: 1,
            .getTransactionCount: 2,
            .getCode: 2,
            .getAbi: 2,
            .getBalance: 2,
            .newFilter: 1,
            .newBlockFilter: 0,
            .uninstallFilter: 1,
            .getFilterChanges: 1,
            .getFilterLogs: 1,
            .getTransactionProof: 1,
            .getMetaData: 1,
            .getBlockHeader: 1,
            .getStateProof: 3
        ]

        return mapping[self] ?? 0
    }
}

public struct RequestFabric {
    public static func prepareRequest(_ method: Method, parameters: [Encodable]) -> Request {
        var request = Request()
        request.method = method
        let pars = Params(params: parameters)
        request.params = pars
        return request
    }
}
