//
//  Response.swift
//  AppChain
//
//  Created by Yate Fulham on 2018/08/10.
//  Copyright © 2018 Cryptape. All rights reserved.
//

import Foundation
import BigInt

// swiftlint:disable cyclomatic_complexity

/// JSON RPC response structure for serialization and deserialization purposes.
public struct Response: Decodable {
    public var id: Int
    public var jsonrpc = "2.0"
    public var result: Any?
    public var error: ErrorMessage?
    public var message: String?

    enum ResponseKeys: String, CodingKey {
        case id
        case jsonrpc
        case result
        case error
    }

    public init(id: Int, jsonrpc: String, result: Any?, error: ErrorMessage?) {
        self.id = id
        self.jsonrpc = jsonrpc
        self.result = result
        self.error = error
    }

    public struct ErrorMessage: Decodable {
        public var code: Int
        public var message: String
    }

    internal var decodableTypes: [Decodable.Type] = [
        [EventLog].self,
        [TransactionDetails].self,
        [TransactionReceipt].self,
        [Block].self,
        [String].self,
        [Int].self,
        [Bool].self,
        EventLog.self,
        TransactionDetails.self,
        TransactionReceipt.self,
        TransactionSendingResult.self,
        Block.self,
        MetaData.self,
        String.self,
        Int.self,
        Bool.self,
        [String: String].self,
        [String: Int].self
    ]

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ResponseKeys.self)
        let id: Int = try container.decode(Int.self, forKey: .id)
        let jsonrpc: String = try container.decode(String.self, forKey: .jsonrpc)
        let errorMessage = try container.decodeIfPresent(ErrorMessage.self, forKey: .error)
        if errorMessage != nil {
            self.init(id: id, jsonrpc: jsonrpc, result: nil, error: errorMessage)
            return
        }
        var result: Any?
        if let rawValue = try? container.decodeIfPresent(String.self, forKey: .result) {
            result = rawValue
        } else if let rawValue = try? container.decodeIfPresent(Int.self, forKey: .result) {
            result = rawValue
        } else if let rawValue = try? container.decodeIfPresent(Bool.self, forKey: .result) {
            result = rawValue
        } else if let rawValue = try? container.decodeIfPresent(EventLog.self, forKey: .result) {
            result = rawValue
        } else if let rawValue = try? container.decodeIfPresent(Block.self, forKey: .result) {
            result = rawValue
        } else if let rawValue = try? container.decodeIfPresent(TransactionReceipt.self, forKey: .result) {
            result = rawValue
        } else if let rawValue = try? container.decodeIfPresent(TransactionSendingResult.self, forKey: .result) {
            result = rawValue
        } else if let rawValue = try? container.decodeIfPresent(TransactionDetails.self, forKey: .result) {
            result = rawValue
        } else if let rawValue = try? container.decodeIfPresent([EventLog].self, forKey: .result) {
            result = rawValue
        } else if let rawValue = try? container.decodeIfPresent([Block].self, forKey: .result) {
            result = rawValue
        } else if let rawValue = try? container.decodeIfPresent(MetaData.self, forKey: .result) {
            result = rawValue
        } else if let rawValue = try? container.decodeIfPresent([TransactionReceipt].self, forKey: .result) {
            result = rawValue
        } else if let rawValue = try? container.decodeIfPresent([TransactionDetails].self, forKey: .result) {
            result = rawValue
        } else if let rawValue = try? container.decodeIfPresent([Bool].self, forKey: .result) {
            result = rawValue
        } else if let rawValue = try? container.decodeIfPresent([Int].self, forKey: .result) {
            result = rawValue
        } else if let rawValue = try? container.decodeIfPresent([String].self, forKey: .result) {
            result = rawValue
        } else if let rawValue = try? container.decodeIfPresent([String: String].self, forKey: .result) {
            result = rawValue
        } else if let rawValue = try? container.decodeIfPresent([String: Int].self, forKey: .result) {
            result = rawValue
        }
        self.init(id: id, jsonrpc: jsonrpc, result: result, error: nil)
    }

    /// Get the JSON RCP reponse value by deserializing it into some native <T> class.
    ///
    /// Returns nil if serialization fails
    public func getValue<T>() -> T? {
        let slf = T.self
        if slf == BigUInt.self {
            guard let string = self.result as? String else { return nil }
            guard let value = BigUInt(string.stripHexPrefix(), radix: 16) else { return nil }
            return value as? T
        } else if slf == BigInt.self {
            guard let string = self.result as? String else { return nil }
            guard let value = BigInt(string.stripHexPrefix(), radix: 16) else { return nil }
            return value as? T
        } else if slf == Data.self {
            guard let string = self.result as? String else { return nil }
            guard let value = Data.fromHex(string) else { return nil }
            return value as? T
        } else if slf == Address.self {
            guard let string = self.result as? String else { return nil }
            guard let value = Address(string) else { return nil }
            return value as? T
        } else if slf == [BigUInt].self {
            guard let string = self.result as? [String] else { return nil }
            let values = string.compactMap { (str) -> BigUInt? in
                return BigUInt(str.stripHexPrefix(), radix: 16)
            }
            return values as? T
        } else if slf == [BigInt].self {
            guard let string = self.result as? [String] else { return nil }
            let values = string.compactMap { (str) -> BigInt? in
                return BigInt(str.stripHexPrefix(), radix: 16)
            }
            return values as? T
        } else if slf == [Data].self {
            guard let string = self.result as? [String] else { return nil }
            let values = string.compactMap { (str) -> Data? in
                return Data.fromHex(str)
            }
            return values as? T
        } else if slf == [Address].self {
            guard let string = self.result as? [String] else { return nil }
            let values = string.compactMap { (str) -> Address? in
                return Address(str)
            }
            return values as? T
        }
        guard let value = self.result as? T else { return nil }
        return value
    }
}

/// JSON RPC batch response structure for serialization and deserialization purposes.
public struct ResponseBatch: Decodable {
    var responses: [Response]

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let responses = try container.decode([Response].self)
        self.responses = responses
    }
}
