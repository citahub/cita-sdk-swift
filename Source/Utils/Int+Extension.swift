//
//  Int+Extension.swift
//  CITA
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
    static func fromHex(_ hex: String) -> BigUInt? {
        return BigUInt(hex.stripHexPrefix(), radix: 16)
    }

    func toHexString() -> String {
        return String(self, radix: 16)
    }

    func toUInt256Hex() -> String? {
        let max = BigUInt("10", radix: 2)!.power(256) - 1
        let zero = String(repeating: "0", count: 64)
        guard self <= max else {
            return nil
        }

        let hex = toHexString()
        let padding = zero.prefix(zero.count - hex.count)
        return padding + hex
    }
}
