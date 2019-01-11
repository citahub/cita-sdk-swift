//
//  Block.swift
//  CITA
//
//  Created by Yate Fulham on 2018/08/13.
//  Copyright © 2018 Cryptape. All rights reserved.
//

import Foundation
import BigInt

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
            throw CITAError.dataError
        }
        self.version = version

        guard let hash = try DecodeUtils.decodeHexToData(container, key: .hash) else { throw CITAError.dataError }
        self.hash = hash

        let header = try container.decode(BlockHeader.self, forKey: .header)
        self.header = header

        let body = try container.decode(BlockBody.self, forKey: .body)
        self.body = body
    }
}
