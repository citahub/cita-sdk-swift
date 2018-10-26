//
//  Address.swift
//  AppChain
//
//  Created by James Chen on 2018/09/20.
//  Copyright © 2018 Cryptape. All rights reserved.
//

import Foundation

/// Nervos Address
/// A Nervos address has same format as Ethereum, but doesn't support EIP55 checksum.
public struct Address: Equatable {
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
