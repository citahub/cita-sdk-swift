//
//  Method.swift
//  Nervos
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

    public var requiredNumOfParameters: Int {
        switch self {
        case .call:
            return 2
        case .getTransactionCount:
            return 2
        case .getBalance:
            return 2
        case .getCode:
            return 2
        case .getBlockByHash:
            return 2
        case .getBlockByNumber:
            return 2
        case .peerCount:
            return 0
        case .blockNumber:
            return 0
        default:
            return 1
        }
    }
}

public struct JSONRPCRequestFabric {
    public static func prepareRequest(_ method: Method, parameters: [Encodable]) -> Request {
        var request = Request()
        request.method = method
        let pars = Params(params: parameters)
        request.params = pars
        return request
    }
}
