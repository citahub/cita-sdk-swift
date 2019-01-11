//
//  MetaData.swift
//  CITA
//
//  Created by Yate Fulham on 2018/08/10.
//  Copyright © 2018 Cryptape. All rights reserved.
//

import Foundation
import BigInt

public struct MetaData: Decodable {
    public var chainId: String
    public var chainName: String
    public var `operator`: String
    public var website: String
    public var genesisTimestamp: BigUInt
    public var validators: [String]
    public var blockInterval: BigUInt
    public var tokenName: String
    public var tokenSymbol: String
    public var tokenAvatar: String
    public var version: UInt32

    enum CodingKeys: String, CodingKey {
        case chainId
        case chainIdV1
        case chainName
        case `operator`
        case website
        case genesisTimestamp
        case validators
        case blockInterval
        case tokenName
        case tokenSymbol
        case tokenAvatar
        case version
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.version = try container.decode(UInt32.self, forKey: .version)

        if version == 0 {
            self.chainId = String(try container.decode(UInt32.self, forKey: .chainId))
        } else {
            self.chainId = try container.decode(String.self, forKey: .chainIdV1)
        }

        self.chainName = try container.decode(String.self, forKey: .chainName)

        self.operator = try container.decode(String.self, forKey: .operator)

        self.website = try container.decode(String.self, forKey: .website)

        guard let genesisTimestamp = try DecodeUtils.decodeIntToBigUInt(container, key: .genesisTimestamp) else { throw CITAError.dataError }
        self.genesisTimestamp = genesisTimestamp

        self.validators = try container.decode([String].self, forKey: .validators)

        guard let blockInterval = try DecodeUtils.decodeIntToBigUInt(container, key: .blockInterval) else { throw CITAError.dataError }
        self.blockInterval = blockInterval

        self.tokenName = try container.decode(String.self, forKey: .tokenName)

        self.tokenSymbol = try container.decode(String.self, forKey: .tokenSymbol)

        self.tokenAvatar = try container.decode(String.self, forKey: .tokenAvatar)
    }
}
