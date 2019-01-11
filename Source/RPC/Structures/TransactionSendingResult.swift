//
//  TransactionSendingResult.swift
//  CITA
//
//  Created by Yate Fulham on 2018/08/14.
//  Copyright © 2018 Cryptape. All rights reserved.
//

import Foundation

public struct TransactionSendingResult: Decodable {
    public var status: String
    public var hash: Data

    enum CodingKeys: String, CodingKey {
        case status
        case hash
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        status = try container.decode(String.self, forKey: .status)
        hash = try DecodeUtils.decodeHexToData(container, key: .hash)!
    }
}
