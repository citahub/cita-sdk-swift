//
//  BlockHeader.swift
//  AppChain
//
//  Created by James Chen on 2018/10/27.
//  Copyright © 2018 Cryptape. All rights reserved.
//

import Foundation
import BigInt

public struct BlockHeader: Decodable {
    public var timestamp: BigUInt
    public var prevHash: Data
    public var proof: BftProof?
    public var stateRoot: Data
    public var transactionsRoot: Data
    public var receiptsRoot: Data
    public var quotaUsed: BigUInt
    public var number: BigUInt
    public var proposer: Data

    enum CodingKeys: String, CodingKey {
        case timestamp
        case prevHash
        case proof
        case stateRoot
        case transactionsRoot
        case receiptsRoot
        case quotaUsed
        case gasUsed  // Version 0
        case number
        case proposer
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        guard let timestamp = try DecodeUtils.decodeIntToBigUInt(container, key: .timestamp) else { throw AppChainError.dataError }
        self.timestamp = timestamp

        guard let prevHash = try DecodeUtils.decodeHexToData(container, key: .prevHash) else { throw AppChainError.dataError }
        self.prevHash = prevHash

        proof = try? container.decode(BftProof.self, forKey: .proof)

        guard let stateRoot = try DecodeUtils.decodeHexToData(container, key: .stateRoot) else { throw AppChainError.dataError }
        self.stateRoot = stateRoot

        guard let transactionsRoot = try DecodeUtils.decodeHexToData(container, key: .transactionsRoot) else { throw AppChainError.dataError }
        self.transactionsRoot = transactionsRoot

        guard let receiptsRoot = try DecodeUtils.decodeHexToData(container, key: .receiptsRoot) else { throw AppChainError.dataError }
        self.receiptsRoot = receiptsRoot

        var quotaUsed = try DecodeUtils.decodeHexToBigUInt(container, key: .quotaUsed, allowOptional: true)
        if quotaUsed == nil {
            quotaUsed = try DecodeUtils.decodeHexToBigUInt(container, key: .gasUsed, allowOptional: true)
        }
        if quotaUsed == nil {
            throw AppChainError.dataError
        }
        self.quotaUsed = quotaUsed!

        guard let number = try DecodeUtils.decodeHexToBigUInt(container, key: .number) else { throw AppChainError.dataError }
        self.number = number

        guard let proposer = try DecodeUtils.decodeHexToData(container, key: .proposer) else { throw AppChainError.dataError }
        self.proposer = proposer
    }
}
