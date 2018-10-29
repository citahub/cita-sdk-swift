//
//  Address.swift
//  AppChain
//
//  Created by James Chen on 2018/09/20.
//  Copyright © 2018 Cryptape. All rights reserved.
//

import Foundation

/// AppChain Address
/// An AppChain address has same format as Ethereum, but doesn't support EIP55 checksum.
public struct Address: Equatable, Codable {
    private let addressString: String

    public init?(_ addressString: String) {
        guard Address.isValid(addressString) else {
            return nil
        }

        self.addressString = addressString.stripHexPrefix()
    }

    public init?(_ data: Data) {
        self.init(data.toHexString())
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let stringValue = try container.decode(String.self)
        self.init(stringValue)!
    }

    public func encode(to encoder: Encoder) throws {
        let value = address.lowercased()
        var signleValuedCont = encoder.singleValueContainer()
        try signleValuedCont.encode(value)
    }

    public var address: String {
        return addressString.addHexPrefix()
    }

    public static func isValid(_ address: String) -> Bool {
        if address == "0x" {
            return true
        }

        let predicate = NSPredicate(format: "SELF MATCHES[c] %@", "^[0-9a-f]{40}$")
        return predicate.evaluate(with: address.stripHexPrefix())
    }

    public static func == (lhs: Address, rhs: Address) -> Bool {
        return lhs.address.lowercased() == rhs.address.lowercased()
    }
}
