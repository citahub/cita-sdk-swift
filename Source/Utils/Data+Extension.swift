//
//  Data+Extension.swift
//  AppChain
//
//  Created by James Chen on 2018/10/28.
//  Copyright © 2018 Cryptape. All rights reserved.
//

import Foundation
import CryptoSwift

extension Data {
    func setLengthLeft(_ toBytes: UInt64, isNegative: Bool = false ) -> Data? {
        let existingLength = UInt64(count)
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
        let existingLength = UInt64(count)
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

    public static func randomBytes(length: Int) -> Data? {
        for _ in 0...1024 {
            var data = Data(repeating: 0, count: length)
            let result = data.withUnsafeMutableBytes { (mutableBytes: UnsafeMutablePointer<UInt8>) -> Int32 in
                SecRandomCopyBytes(kSecRandomDefault, 32, mutableBytes)
            }
            if result == errSecSuccess {
                return data
            }
        }
        return nil
    }

    public static func fromHex(_ hex: String) -> Data? {
        let string = hex.lowercased().stripHexPrefix()
        let array = [UInt8](hex: string)
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
