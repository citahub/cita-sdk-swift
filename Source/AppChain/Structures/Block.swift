//
//  Block.swift
//  Nervos
//
//  Created by Yate Fulham on 2018/08/13.
//  Copyright © 2018 Cryptape. All rights reserved.
//

import Foundation
import BigInt

// TODO: full block structure.
public struct Block: Decodable {
    public var version: Int
    public var hash: String
    // header
    // public var transactions: [TransactionInBlock]

    enum CodingKeys: String, CodingKey {
        case version
        case hash
       // case header
       // case body
    }

    /*
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        guard let hash = try decodeHexToData(container, key: .hash) else { throw NervosError.dataError }
        self.hash = hash

        //let transactions = try container.decode([TransactionInBlock].self, forKey: .transactions)
        //self.transactions = transactions
    }*/
}
