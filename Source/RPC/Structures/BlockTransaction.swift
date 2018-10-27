//
//  BlockTransaction.swift
//  AppChain
//
//  Created by James Chen on 2018/10/27.
//  Copyright © 2018 Cryptape. All rights reserved.
//

import Foundation

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
