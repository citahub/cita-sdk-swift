//
//  Block.swift
//  Nervos
//
//  Created by Yate Fulham on 2018/08/13.
//  Copyright © 2018 Cryptape. All rights reserved.
//

import Foundation
import BigInt

public struct BlockHeader: Decodable {
    public var timestamp: BigUInt
    public var prevHash: Data
    public var proof: Proof?
    public var stateRoot: Data
    public var transactionsRoot: Data
    public var receiptsRoot: Data
    public var gasUsed: Data
    public var number: Data
    public var proposer: Data

    enum CodingKeys: String, CodingKey {
        case timestamp
        case prevHash
        case proof
        case stateRoot
        case transactionsRoot
        case receiptsRoot
        case gasUsed
        case number
        case proposer
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        guard let timestamp = try DecodeUtils.decodeIntToBigUInt(container, key: .timestamp) else { throw NervosError.dataError }
        self.timestamp = timestamp

        guard let prevHash = try DecodeUtils.decodeHexToData(container, key: .prevHash) else { throw NervosError.dataError }
        self.prevHash = prevHash

        proof = try? container.decode(Proof.self, forKey: .proof)

        guard let stateRoot = try DecodeUtils.decodeHexToData(container, key: .stateRoot) else { throw NervosError.dataError }
        self.stateRoot = stateRoot

        guard let transactionsRoot = try DecodeUtils.decodeHexToData(container, key: .transactionsRoot) else { throw NervosError.dataError }
        self.transactionsRoot = transactionsRoot

        guard let receiptsRoot = try DecodeUtils.decodeHexToData(container, key: .receiptsRoot) else { throw NervosError.dataError }
        self.receiptsRoot = receiptsRoot

        guard let gasUsed = try DecodeUtils.decodeHexToData(container, key: .gasUsed) else { throw NervosError.dataError }
        self.gasUsed = gasUsed

        guard let number = try DecodeUtils.decodeHexToData(container, key: .number) else { throw NervosError.dataError }
        self.number = number

        guard let proposer = try DecodeUtils.decodeHexToData(container, key: .proposer) else { throw NervosError.dataError }
        self.proposer = proposer
    }
}

public struct Proof: Decodable {
    public var nervosProof: NervosProof

    enum CodingKeys: String, CodingKey {
        case Tendermint
        case Bft
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let bft = try container.decodeIfPresent(NervosProof.self, forKey: .Bft) {
            self.nervosProof = bft
        } else {
            self.nervosProof = try container.decode(NervosProof.self, forKey: .Tendermint)
        }
    }
}

public struct NervosProof: Decodable {
    public var proposal: Data
    public var height: BigUInt
    public var round: BigUInt
    public var commits: [Data: Data]

    enum CodingKeys: String, CodingKey {
        case proposal
        case height
        case round
        case commits
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        guard let proposal = try DecodeUtils.decodeHexToData(container, key: .proposal) else { throw NervosError.dataError }
        self.proposal = proposal

        guard let height = try DecodeUtils.decodeIntToBigUInt(container, key: .height) else { throw NervosError.dataError }
        self.height = height

        guard let round = try DecodeUtils.decodeIntToBigUInt(container, key: .round) else { throw NervosError.dataError }
        self.round = round

        let commitsStrings = try container.decode([String: String].self, forKey: .commits)
        var commits = [Data: Data]()

        for str in commitsStrings {
            guard let d = Data.fromHex(str.key) else { throw NervosError.dataError }
            guard let c = Data.fromHex(str.value) else { throw NervosError.dataError }
            commits[d] = c
        }
        self.commits = commits
    }
}

public struct BlockBody: Decodable {
    public var transactions: [BlockTransaction]? = []
    enum CodingKeys: String, CodingKey {
        case transactions
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let transactions = try container.decode([BlockTransaction]?.self, forKey: .transactions)
        self.transactions = transactions
    }
}

public struct BlockTransaction: Decodable {
    public var hash: Data?
    public var content: Data?
    enum CodingKeys: String, CodingKey {
        case hash
        case content
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        guard let hash = try DecodeUtils.decodeHexToData(container, key: .hash) else { throw NervosError.dataError }
        self.hash = hash

        guard let content = try DecodeUtils.decodeHexToData(container, key: .content) else { throw NervosError.dataError }
        self.content = content
    }
}

public struct Block: Decodable {
    public var version: BigUInt
    public var hash: Data
    public var header: BlockHeader
    public var body: BlockBody

    enum CodingKeys: String, CodingKey {
        case version
        case hash
        case header
        case body
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        guard let version = try DecodeUtils.decodeIntToBigUInt(container, key: .version) else {
            throw NervosError.dataError
        }
        self.version = version

        guard let hash = try DecodeUtils.decodeHexToData(container, key: .hash) else { throw NervosError.dataError }
        self.hash = hash

        let header = try container.decode(BlockHeader.self, forKey: .header)
        self.header = header

        let body = try container.decode(BlockBody.self, forKey: .body)
        self.body = body
    }
}
