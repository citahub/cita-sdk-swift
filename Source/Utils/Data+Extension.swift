//
//  Data+Extension.swift
//  Nervos
//
//  Created by Yate Fulham on 2018/08/13.
//  Copyright © 2018 Cryptape. All rights reserved.
//

import Foundation

extension Data {
    public static func fromHex(_ hex: String) -> Data? {
        let string = hex.lowercased().stripHexPrefix()
        let array = [UInt8].init(hex: string)
        if array.count == 0 {
            if hex == "0x" || hex == "" {
                return Data()
            } else {
                return nil
            }
        }
        return Data(array)
    }
}
