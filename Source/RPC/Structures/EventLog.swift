//
//  EventLog.swift
//  CITA
//
//  Created by James Chen on 2018/10/28.
//  Copyright © 2018 Cryptape. All rights reserved.
//

import Foundation
import BigInt

public struct EventLog: Decodable {
    public var address: Address
    public var blockHash: Data
    public var blockNumber: BigUInt
    public var data: Data
    public var logIndex: BigUInt
    public var removed: Bool
    public var topics: [Data]
    public var transactionHash: Data
    public var transactionIndex: BigUInt

    enum CodingKeys: String, CodingKey {
        case address
        case blockHash
        case blockNumber
        case data
        case logIndex
        case removed
        case topics
        case transactionHash
        case transactionIndex
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        let address = try container.decode(Address.self, forKey: .address)
        self.address = address

        guard let blockNumber = try DecodeUtils.decodeHexToBigUInt(container, key: .blockNumber) else { throw CITAError.dataError }
        self.blockNumber = blockNumber

        guard let blockHash = try DecodeUtils.decodeHexToData(container, key: .blockHash) else { throw CITAError.dataError }
        self.blockHash = blockHash

        guard let transactionIndex = try DecodeUtils.decodeHexToBigUInt(container, key: .transactionIndex) else { throw CITAError.dataError }
        self.transactionIndex = transactionIndex

        guard let transactionHash = try DecodeUtils.decodeHexToData(container, key: .transactionHash) else { throw CITAError.dataError }
        self.transactionHash = transactionHash

        guard let data = try DecodeUtils.decodeHexToData(container, key: .data) else { throw CITAError.dataError }
        self.data = data

        guard let logIndex = try DecodeUtils.decodeHexToBigUInt(container, key: .logIndex) else { throw CITAError.dataError }
        self.logIndex = logIndex

        let removed = try DecodeUtils.decodeHexToBigUInt(container, key: .removed, allowOptional: true)
        if removed == 1 {
            self.removed = true
        } else {
            self.removed = false
        }

        let topicsStrings = try container.decode([String].self, forKey: .topics)
        var allTopics = [Data]()
        for top in topicsStrings {
            guard let topic = Data.fromHex(top) else { throw CITAError.dataError }
            allTopics.append(topic)
        }
        self.topics = allTopics
    }
}
