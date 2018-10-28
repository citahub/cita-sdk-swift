//
//  Data+Extension.swift
//  AppChain
//
//  Created by James Chen on 2018/10/28.
//  Copyright © 2018 Cryptape. All rights reserved.
//

import Foundation

extension Data {
    func setLengthLeft(_ toBytes: UInt64, isNegative: Bool = false ) -> Data? {
        let existingLength = UInt64(self.count)
        if existingLength == toBytes {
            return Data(self)
        } else if existingLength > toBytes {
            return nil
        }
        var data: Data
        if isNegative {
            data = Data(repeating: UInt8(255), count: Int(toBytes - existingLength))
        } else {
            data = Data(repeating: UInt8(0), count: Int(toBytes - existingLength))
        }
        data.append(self)
        return data
    }

    func setLengthRight(_ toBytes: UInt64, isNegative: Bool = false ) -> Data? {
        let existingLength = UInt64(self.count)
        if existingLength == toBytes {
            return Data(self)
        } else if existingLength > toBytes {
            return nil
        }
        var data = Data()
        data.append(self)
        if isNegative {
            data.append(Data(repeating: UInt8(255), count: Int(toBytes - existingLength)))
        } else {
            data.append(Data(repeating: UInt8(0), count: Int(toBytes - existingLength)))
        }
        return data
    }
}
