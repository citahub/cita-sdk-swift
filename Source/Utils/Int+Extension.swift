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

    static func fromHex(_ hex: String) -> BigUInt? {
        return BigUInt(hex.stripHexPrefix(), radix: 16)
    }
}
