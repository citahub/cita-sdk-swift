//
//  Utils.swift
//  Nervos
//
//  Created by James Chen on 2018/10/01.
//  Copyright © 2018 Cryptape. All rights reserved.
//

import Foundation
import BigInt
import Result

public struct Utils {
    static func getQuotaPrice(nervos: Nervos) -> Result<BigUInt, NervosError> {
        let result = ContractCall.request(.getQuotaPrice, nervos: nervos)
        switch result {
        case .success(let quotaPrice):
            return Result(BigUInt.fromHex(quotaPrice)!)
        case .failure(let error):
            return Result.failure(error)
        }
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

        static func request(_ requestType: RequestType, nervos: Nervos) -> Result<String, NervosError> {
            return nervos.appChain.call(request: requestType.rawValue)
        }
    }
}

extension Utils {
    public static func appendPersonalMessagePrefix(for message: Data) -> Data? {
        var prefix = "\u{19}Ethereum Signed Message:\n"
        prefix += String(message.count)
        guard let prefixData = prefix.data(using: .ascii) else {return nil}
        var data = Data()
        if message.count >= prefixData.count && prefixData == message[0 ..< prefixData.count] {
            data.append(message)
        } else {
            data.append(prefixData)
            data.append(message)
        }
        return data
    }

    public static func hashPersonalMessage(_ personalMessage: Data) -> Data? {
        guard let message = appendPersonalMessagePrefix(for: personalMessage) else { return nil }
        return hashMessage(message)
    }

    public static func hashMessage(_ message: Data) -> Data? {
        return message.sha3(.keccak256)
    }
}
