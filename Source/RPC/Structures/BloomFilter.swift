//
//  BloomFilter.swift
//  AppChain
//
//  Created by James Chen on 2018/10/28.
//  Copyright © 2018 Cryptape. All rights reserved.
//

import Foundation
import BigInt

public struct BloomFilter {
    public var bytes = Data(repeatElement(UInt8(0), count: 256))
    public init?(_ biguint: BigUInt) {
        guard let data = biguint.serialize().setLengthLeft(256) else {return nil}
        bytes = data
    }
    public init() {}
    public init(_ data: Data) {
        let padding = Data(repeatElement(UInt8(0), count: 256 - data.count))
        bytes = padding + data
    }
    public func asBigUInt() -> BigUInt {
        return BigUInt(self.bytes)
    }
}
