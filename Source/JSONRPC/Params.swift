//
//  Params.swift
//  Nervos
//
//  Created by Yate Fulham on 2018/08/10.
//  Copyright © 2018 Cryptape. All rights reserved.
//

import Foundation

/// Transaction parameters JSON structure for interaction with AppChain.
/// TODO: update to adapt AppChain tx params.
public struct TransactionParameters: Codable {
    public var data: String?
    public var from: String?
    public var gas: String?
    public var gasPrice: String?
    public var to: String?
    public var value: String? = "0x0"

    public init(from: String?, to: String?) {
        self.from = from
        self.to = to
    }
}

/// Event filter parameters JSON structure for interaction with AppChain.
public struct EventFilterParameters: Codable {
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
            if let p = par as? TransactionParameters {
                try container.encode(p)
            } else if let p = par as? String {
                try container.encode(p)
            } else if let p = par as? Bool {
                try container.encode(p)
            } else if let p = par as? EventFilterParameters {
                try container.encode(p)
            }
        }
    }
}
