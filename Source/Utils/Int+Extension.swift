//
//  Int+Extension.swift
//  Nervos
//
//  Created by Yate Fulham on 2018/08/13.
//  Copyright © 2018 Cryptape. All rights reserved.
//

import Foundation
import BigInt

extension UInt64 {
    func toHexString() -> String {
        return String(self, radix: 16)
    }
}

extension BigUInt {
    func toHexString() -> String {
        return String(self, radix: 16)
    }

    func toUInt256Hex() -> String {
        let max = BigUInt("10", radix: 2)!.power(256) - 1
        let zero = (0...63).map { _ in
            return "0"
        }.joined()
        guard self <= max else {
            return zero
        }

        let hex = toHexString()
        let padding = zero.prefix(zero.count - hex.count)
        return padding + hex
    }

    static func fromHex(_ hex: String) -> BigUInt? {
        return BigUInt(hex.stripHexPrefix(), radix: 16)
    }
}
