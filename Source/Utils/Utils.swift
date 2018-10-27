//
//  Utils.swift
//  AppChain
//
//  Created by James Chen on 2018/10/01.
//  Copyright © 2018 Cryptape. All rights reserved.
//

import Foundation
import BigInt
import Result

public struct Utils {
    static func getQuotaPrice(appChain: AppChain) -> Result<BigUInt, AppChainError> {
        let result = ContractCall.request(.getQuotaPrice, appChain: appChain)
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

        static func request(_ requestType: RequestType, appChain: AppChain) -> Result<String, AppChainError> {
            return appChain.rpc.call(request: requestType.rawValue)
        }
    }
}
