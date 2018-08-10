//
//  MetaData.swift
//  Nervos
//
//  Created by Yate Fulham on 2018/08/10.
//  Copyright © 2018 Cryptape. All rights reserved.
//

import Foundation
import BigInt

public struct MetaData: Decodable {
    public var chainId: BigUInt
    public var chainName: String
    public var `operator`: String
    public var website: String
    public var genesisTimestamp: BigUInt
    public var validators: [String]
    public var blockInterval: BigUInt
    public var tokenName: String
    public var tokenSymbol: String
    public var tokenAvatar: String

    enum CodingKeys: String, CodingKey {
        case chainId
        case chainName
        case `operator`
        case website
        case genesisTimestamp
        case validators
        case blockInterval
        case tokenName
        case tokenSymbol
        case tokenAvatar
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        guard let chainId = try decodeIntToBigUInt(container, key: .chainId) else { throw NervosError.dataError }
        self.chainId = chainId

        self.chainName = try container.decode(String.self, forKey: .chainName)

        self.operator = try container.decode(String.self, forKey: .operator)

        self.website = try container.decode(String.self, forKey: .website)

        guard let genesisTimestamp = try decodeIntToBigUInt(container, key: .genesisTimestamp) else { throw NervosError.dataError }
        self.genesisTimestamp = genesisTimestamp

        self.validators = try container.decode([String].self, forKey: .validators)

        guard let blockInterval = try decodeIntToBigUInt(container, key: .blockInterval) else { throw NervosError.dataError }
        self.blockInterval = blockInterval

        self.tokenName = try container.decode(String.self, forKey: .tokenName)

        self.tokenSymbol = try container.decode(String.self, forKey: .tokenSymbol)

        self.tokenAvatar = try container.decode(String.self, forKey: .tokenAvatar)
    }
}

private func decodeHexToData<T>(_ container: KeyedDecodingContainer<T>, key: KeyedDecodingContainer<T>.Key, allowOptional: Bool = false) throws -> Data? {
    if allowOptional {
        let string = try? container.decode(String.self, forKey: key)
        if string != nil {
            guard let data = Data.fromHex(string!) else { throw NervosError.dataError }
            return data
        }
        return nil
    } else {
        let string = try container.decode(String.self, forKey: key)
        guard let data = Data.fromHex(string) else { throw NervosError.dataError }
        return data
    }
}

private func decodeHexToBigUInt<T>(_ container: KeyedDecodingContainer<T>, key: KeyedDecodingContainer<T>.Key, allowOptional: Bool = false) throws -> BigUInt? {
    if allowOptional {
        let string = try? container.decode(String.self, forKey: key)
        if string != nil {
            guard let number = BigUInt(string!.stripHexPrefix(), radix: 16) else { throw NervosError.dataError }
            return number
        }
        return nil
    } else {
        let string = try container.decode(String.self, forKey: key)
        guard let number = BigUInt(string.stripHexPrefix(), radix: 16) else { throw NervosError.dataError }
        return number
    }
}

private func decodeIntToBigUInt<T>(_ container: KeyedDecodingContainer<T>, key: KeyedDecodingContainer<T>.Key, allowOptional: Bool = false) throws -> BigUInt? {
    if allowOptional {
        let string = try? container.decode(String.self, forKey: key)
        if string != nil {
            guard let number = BigUInt(string!.stripHexPrefix(), radix: 16) else { throw NervosError.dataError }
            return number
        }
        return nil
    } else {
        let int = try container.decode(Int.self, forKey: key)
        return BigUInt(int)
    }
}
