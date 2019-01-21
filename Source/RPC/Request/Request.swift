//
//  Request.swift
//  CITA
//
//  Created by Yate Fulham on 2018/08/10.
//  Copyright © 2018 Cryptape. All rights reserved.
//

import Foundation

/// Global counter object to enumerate JSON RPC requests.
public struct Counter {
    public static var counter = UInt64(1)
    public static var lockQueue = DispatchQueue(label: "counterQueue")
    public static func increment() -> UInt64 {
        var c: UInt64 = 0
        lockQueue.sync {
            c = Counter.counter
            Counter.counter += 1
        }
        return c
    }
}

/// JSON RPC request structure for serialization and deserialization purposes.
public struct Request: Encodable {
    var jsonrpc: String = "2.0"
    var method: Method?
    var params: Params?
    var id: UInt64 = Counter.increment()

    enum CodingKeys: String, CodingKey {
        case jsonrpc
        case method
        case params
        case id
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(jsonrpc, forKey: .jsonrpc)
        try container.encode(method?.rawValue, forKey: .method)
        try container.encode(params, forKey: .params)
        try container.encode(id, forKey: .id)
    }

    public var isValid: Bool {
        guard let method = self.method else { return false }
        return method.requiredNumOfParameters == params?.params.count
    }
}

/// JSON RPC batch request structure for serialization and deserialization purposes.
public struct RequestBatch: Encodable {
    var requests: [Request]

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(requests)
    }
}
