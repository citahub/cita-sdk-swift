//
//  Proof.swift
//  CITA
//
//  Created by James Chen on 2018/10/27.
//  Copyright © 2018 Cryptape. All rights reserved.
//

import Foundation
import BigInt

public struct BftProof: Decodable {
    public var proof: Proof

    enum CodingKeys: String, CodingKey {
        case Bft
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        proof = try container.decode(Proof.self, forKey: .Bft)
    }
}

public struct Proof: Decodable {
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
        guard let proposal = try DecodeUtils.decodeHexToData(container, key: .proposal) else { throw CITAError.dataError }
        self.proposal = proposal

        guard let height = try DecodeUtils.decodeIntToBigUInt(container, key: .height) else { throw CITAError.dataError }
        self.height = height

        guard let round = try DecodeUtils.decodeIntToBigUInt(container, key: .round) else { throw CITAError.dataError }
        self.round = round

        let commitsStrings = try container.decode([String: String].self, forKey: .commits)
        var commits = [Data: Data]()

        for str in commitsStrings {
            guard let d = Data.fromHex(str.key) else { throw CITAError.dataError }
            guard let c = Data.fromHex(str.value) else { throw CITAError.dataError }
            commits[d] = c
        }
        self.commits = commits
    }
}
