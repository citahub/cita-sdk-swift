//
//  AppChain+Utils.swift
//  Nervos
//
//  Created by XiaoLu on 2018/9/29.
//  Copyright © 2018 Cryptape. All rights reserved.
//

import Foundation
import Result

extension AppChain {
    public struct Utils {

    }
}

extension AppChain.Utils {
    public enum RequestType {
        case getQuotaPrice
    }

    public static func contractMethod(method requestType: RequestType, nervos: Nervos) -> Result<String, NervosError> {
        let result = nervos.appChain.call(request: requestType.rawValue)
        switch result {
        case .success(let hex):
            return Result(hex)
        case .failure(let error):
            return Result.failure(error)
        }
    }
}

extension AppChain.Utils.RequestType {
    var rawValue: CallRequest {
        get {
            switch self {
            case .getQuotaPrice:
                return CallRequest(from: nil, to: "0x6bacc53f", data: "0xffffffffffffffffffffffffffffffffff020010")
            }
        }
    }
}
