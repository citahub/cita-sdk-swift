//
//  Params.swift
//  Nervos
//
//  Created by Yate Fulham on 2018/08/10.
//  Copyright © 2018 Cryptape. All rights reserved.
//

import Foundation

/// CallRequest
public struct CallRequest: Codable {
    public var from: String?
    public var to: String
    public var data: String?

    public init(from: String?, to: String, data: String? = nil) {
        self.from = from
        self.to = to
        self.data = data
    }
}

/// Event filter parameters JSON structure for interaction with AppChain.
public struct Filter: Codable {
    public var fromBlock: String?
    public var toBlock: String?
    public var topics: [[String?]?]?
    public var address: [String?]?
}

/// Raw JSON RPC 2.0 internal flattening wrapper.
public struct Params: Encodable {
    public var params = [Any]()

    public func encode(to encoder: Encoder) throws {
        var container = encoder.unkeyedContainer()
        for par in params {
            if let p = par as? CallRequest {
                try container.encode(p)
            } else if let p = par as? Filter {
                try container.encode(p)
            } else if let p = par as? String {
                try container.encode(p)
            } else if let p = par as? Bool {
                try container.encode(p)
            }
        }
    }
}
