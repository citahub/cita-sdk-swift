//
//  DecodeUtils.swift
//  AppChain
//
//  Created by Yate Fulham on 2018/08/13.
//  Copyright © 2018 Cryptape. All rights reserved.
//

import Foundation
import BigInt

struct DecodeUtils {
    static func decodeHexToBigUInt<T>(_ container: KeyedDecodingContainer<T>, key: KeyedDecodingContainer<T>.Key, allowOptional: Bool = false) throws -> BigUInt? {
        if allowOptional {
            let string = try? container.decode(String.self, forKey: key)
            if string != nil {
                guard let number = BigUInt(string!.stripHexPrefix(), radix: 16) else { throw AppChainError.dataError }
                return number
            }
            return nil
        } else {
            let string = try container.decode(String.self, forKey: key)
            guard let number = BigUInt(string.stripHexPrefix(), radix: 16) else { throw AppChainError.dataError }
            return number
        }
    }

    static func decodeIntToBigUInt<T>(_ container: KeyedDecodingContainer<T>, key: KeyedDecodingContainer<T>.Key, allowOptional: Bool = false) throws -> BigUInt? {
        if allowOptional {
            let string = try? container.decode(String.self, forKey: key)
            if string != nil {
                guard let number = BigUInt(string!.stripHexPrefix(), radix: 16) else { throw AppChainError.dataError }
                return number
            }
            return nil
        } else {
            let int = try container.decode(Int.self, forKey: key)
            return BigUInt(int)
        }
    }

    static func decodeHexToData<T>(_ container: KeyedDecodingContainer<T>, key: KeyedDecodingContainer<T>.Key, allowOptional: Bool = false) throws -> Data? {
        if allowOptional {
            let string = try? container.decode(String.self, forKey: key)
            if string != nil {
                guard let data = Data.fromHex(string!) else { throw AppChainError.dataError }
                return data
            }
            return nil
        } else {
            let string = try container.decode(String.self, forKey: key)
            guard let data = Data.fromHex(string) else { throw AppChainError.dataError }
            return data
        }
    }
}
