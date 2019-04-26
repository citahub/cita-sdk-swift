//
//  TransactionSendingResult.swift
//  CITA
//
//  Created by Yate Fulham on 2018/08/14.
//  Copyright © 2018 Cryptape. All rights reserved.
//

import Foundation

public struct TransactionSendingResult: Codable {
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

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.status, forKey: .status)
        let hashString = self.hash.toHexString().addHexPrefix()
        try container.encode(hashString, forKey: .hash)
    }

    public func json() -> String {
        let jsonEncoder = JSONEncoder()
        let jsonData = try? jsonEncoder.encode(self)
        let json = String(data: jsonData!, encoding: .utf8)!
        return json
    }

}
