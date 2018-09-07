//
//  TransactionDetails.swift
//  Nervos
//
//  Created by Yate Fulham on 2018/08/13.
//  Copyright © 2018 Cryptape. All rights reserved.
//

import Foundation
import BigInt

public struct TransactionDetails: Decodable {
    public var hash: Data
    public var content: String
    public var blockHash: Data?
    public var blockNumber: BigUInt?
    public var index: BigUInt?

    enum CodingKeys: String, CodingKey {
        case hash
        case content
        case blockHash
        case blockNumber
        case index
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        hash = try DecodeUtils.decodeHexToData(container, key: .hash)!
        content = try container.decode(String.self, forKey: .content)
        blockHash = try DecodeUtils.decodeHexToData(container, key: .blockHash, allowOptional: true)
        blockNumber = try DecodeUtils.decodeHexToBigUInt(container, key: .blockNumber, allowOptional: true)
        index = try DecodeUtils.decodeHexToBigUInt(container, key: .index, allowOptional: true)
    }

    public init?(_ json: [String: AnyObject]) {
        guard let hash = json["hash"] as? String else { return nil }
        self.hash = Data.fromHex(hash)!

        guard let content = json["content"] as? String else { return nil }
        self.content = content

        let bh = json["blockHash"] as? String
        if bh != nil {
            guard let blockHash = Data.fromHex(bh!) else { return nil }
            self.blockHash = blockHash
        }
        let bn = json["blockNumber"] as? String
        let ti = json["index"] as? String

        if bn != nil {
            blockNumber = BigUInt(bn!.stripHexPrefix(), radix: 16)
        }
        if ti != nil {
            index = BigUInt(ti!.stripHexPrefix(), radix: 16)
        }
    }
}
