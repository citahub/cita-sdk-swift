//
//  Address.swift
//  CITA
//
//  Created by James Chen on 2018/09/20.
//  Copyright © 2018 Cryptape. All rights reserved.
//

import Foundation
import CryptoSwift

/// CITA Address (same format as Ethereum address).
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

    public var checksumAddress: String {
        return ChecksumMaker(address: addressString).checksum
    }

    public static func isValid(_ address: String) -> Bool {
        if address == "0x" {
            return true
        }

        if !NSPredicate(format: "SELF MATCHES %@", "^(0x)?[0-9a-fA-F]{40}$").evaluate(with: address) {
            return false
        }

        let prefixRemoved = address.stripHexPrefix()
        if prefixRemoved == prefixRemoved.uppercased() || prefixRemoved == prefixRemoved.lowercased() {
            return true
        }
        return ChecksumMaker(address: address).checksum == prefixRemoved.addHexPrefix()
    }

    public static func == (lhs: Address, rhs: Address) -> Bool {
        return lhs.address.lowercased() == rhs.address.lowercased()
    }

    struct ChecksumMaker {
        let address: String

        var checksum: String {
            let lowercased = address.stripHexPrefix().lowercased()
            let hash = lowercased.sha3(.keccak256)

            let checksumed = lowercased.enumerated().map { (idx, ch) -> String in
                let string = String(ch)
                if Int(hash.substring(from: idx).substring(to: 1), radix: 16)! >= 8 {
                    return string.uppercased()
                } else {
                    return string
                }
            }

            return checksumed.joined().addHexPrefix()
        }
    }
}
