//
//  PeersInfo.swift
//  CITA
//
//  Created by XiaoLu on 2019/4/22.
//  Copyright © 2019 Cryptape. All rights reserved.
//

import Foundation
import BigInt

public struct PeerInfo: Decodable {
    public var amount: BigUInt
    public var peers: [String: String]
    public var errorMessage: String?

    enum CodingKeys: String, CodingKey {
        case amount
        case peers
        case errorMessage
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        guard let amount = try DecodeUtils.decodeIntToBigUInt(container, key: .amount) else { throw CITAError.dataError }
        self.amount = amount

        let peers = try container.decode([String: String].self, forKey: .peers)
        self.peers = peers

        let errorMessage = try? container.decode(String.self, forKey: .errorMessage)
        self.errorMessage = errorMessage
    }
}
