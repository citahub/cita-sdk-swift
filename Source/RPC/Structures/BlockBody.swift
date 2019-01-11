//
//  BlockBody.swift
//  CITA
//
//  Created by James Chen on 2018/10/27.
//  Copyright © 2018 Cryptape. All rights reserved.
//

import Foundation

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
