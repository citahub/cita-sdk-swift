//
//  Utils.swift
//  CITA
//
//  Created by James Chen on 2018/10/01.
//  Copyright © 2018 Cryptape. All rights reserved.
//

import Foundation
import BigInt

public struct Utils {
    public static func getQuotaPrice(cita: CITA) throws -> BigUInt {
        let result = try ContractCall.request(.getQuotaPrice, cita: cita)
        return BigUInt.fromHex(result)!
    }
}

extension Utils {
    public static func privateToPublic(_ privateKey: Data) -> Data? {
        return try? Secp256k1.privateToPublic(privateKey: privateKey)
    }

    public static func publicToAddressData(_ publicKey: Data) -> Data? {
        if publicKey.count == 33 {
            guard let decompressedKey = try? Secp256k1.combineSerializedPublicKeys(keys: [publicKey], outputCompressed: false) else {
                return nil
            }
            return publicToAddressData(decompressedKey)
        }
        var stipped = publicKey
        if stipped.count == 65 {
            if stipped[0] != 4 {
                return nil
            }
            stipped = stipped[1...64]
        }
        if stipped.count != 64 {
            return nil
        }
        let sha3 = stipped.sha3(.keccak256)
        let addressData = sha3[12...31]
        return addressData
    }

    public static func publicToAddress(_ publicKey: Data) -> Address? {
        guard let addressData = publicToAddressData(publicKey) else {
            return nil
        }
        let address = addressData.toHexString().addHexPrefix().lowercased()
        return Address(address)
    }
}

extension Utils {
    // swiftlint:disable nesting
    struct ContractCall {
        enum RequestType {
            case getQuotaPrice

            var rawValue: CallRequest {
                switch self {
                case .getQuotaPrice:
                    return CallRequest(from: nil, to: "0xffffffffffffffffffffffffffffffffff020010", data: "0x6bacc53f")
                }
            }
        }

        static func request(_ requestType: RequestType, cita: CITA) throws -> String {
            return try cita.rpc.call(request: requestType.rawValue)
        }
    }
}
