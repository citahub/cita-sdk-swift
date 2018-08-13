//
//  TransactionReceipt.swift
//  Nervos
//
//  Created by Yate Fulham on 2018/08/13.
//  Copyright © 2018 Cryptape. All rights reserved.
//

import Foundation
import BigInt
import web3swift

public typealias TransactionReceipt = web3swift.TransactionReceipt
// TODO: implement Vervos.TransactionReceipt
/*
public struct TransactionReceipt: Decodable {
    public var transactionHash: Data
    public var transactionIndex: BigUInt
    public var blockHash: Data
    public var blockNumber: BigUInt
    public var cumulativeGasUsed: BigUInt
    public var gasUsed: BigUInt
    public var contractAddress: EthereumAddress?
    public var logs: [EventLog]
    public var root: String?
    public var logsBloom: EthereumBloomFilter?
    public var errorMessage: String?

    enum CodingKeys: String, CodingKey {
        case blockHash
        case blockNumber
        case transactionHash
        case transactionIndex
        case contractAddress
        case cumulativeGasUsed
        case gasUsed
        case logs
        case root
        case logsBloom
        case errorMessage
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        guard let blockNumber = try DecodeUtils.decodeHexToBigUInt(container, key: .blockNumber) else { throw NervosError.dataError }
        self.blockNumber = blockNumber

        guard let blockHash = try DecodeUtils.decodeHexToData(container, key: .blockHash) else { throw NervosError.dataError }
        self.blockHash = blockHash

        guard let transactionIndex = try DecodeUtils.decodeHexToBigUInt(container, key: .transactionIndex) else { throw NervosError.dataError }
        self.transactionIndex = transactionIndex

        guard let transactionHash = try DecodeUtils.decodeHexToData(container, key: .transactionHash) else { throw NervosError.dataError }
        self.transactionHash = transactionHash

        let contractAddress = try container.decodeIfPresent(EthereumAddress.self, forKey: .contractAddress)
        if contractAddress != nil {
            self.contractAddress = contractAddress
        }

        guard let cumulativeGasUsed = try DecodeUtils.decodeHexToBigUInt(container, key: .cumulativeGasUsed) else { throw NervosError.dataError }
        self.cumulativeGasUsed = cumulativeGasUsed

        guard let gasUsed = try DecodeUtils.decodeHexToBigUInt(container, key: .gasUsed) else { throw NervosError.dataError }
        self.gasUsed = gasUsed

        let logsData = try DecodeUtils.decodeHexToData(container, key: .logsBloom, allowOptional: true)
        if logsData != nil && logsData!.count > 0 {
            self.logsBloom = EthereumBloomFilter(logsData!)
        }

        let logs = try container.decode([EventLog].self, forKey: .logs)
        self.logs = logs

        root = try container.decode(String.self, forKey: .root)
        errorMessage = try container.decode(String.self, forKey: .errorMessage)
    }

    public init(transactionHash: Data, blockHash: Data, blockNumber: BigUInt, transactionIndex: BigUInt, contractAddress: EthereumAddress?,
                cumulativeGasUsed: BigUInt, gasUsed: BigUInt, logs: [EventLog], root: String?, logsBloom: EthereumBloomFilter?) {
        self.transactionHash = transactionHash
        self.blockHash = blockHash
        self.blockNumber = blockNumber
        self.transactionIndex = transactionIndex
        self.contractAddress = contractAddress
        self.cumulativeGasUsed = cumulativeGasUsed
        self.gasUsed = gasUsed
        self.logs = logs
        self.root = root
        self.logsBloom = logsBloom
    }
}
*/
