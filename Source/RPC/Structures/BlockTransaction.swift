//
//  BlockTransaction.swift
//  CITA
//
//  Created by James Chen on 2018/10/27.
//  Copyright © 2018 Cryptape. All rights reserved.
//

import Foundation

public struct BlockTransaction: Decodable {
    public var hash: Data
    public var content: Data?
    public var from: String?
    enum CodingKeys: String, CodingKey {
        case hash
        case content
        case from
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        guard let hash = try DecodeUtils.decodeHexToData(container, key: .hash) else { throw CITAError.dataError }
        self.hash = hash

        self.content = try DecodeUtils.decodeHexToData(container, key: .content, allowOptional: true)

        self.from = try? container.decode(String.self, forKey: .from)
    }
}
