//
//  CITAError.swift
//  CITA
//
//  Created by James Chen on 2018/10/27.
//  Copyright © 2018 Cryptape. All rights reserved.
//

import Foundation

public enum CITAError: Error {
    case transactionSerializationError
    case connectionError
    case dataError
    case inputError(desc: String)
    case nodeError(desc: String)
    case processingError(desc: String)
    case generalError(err: Error)
    case unknownError

    var description: String {
        switch self {
        case .transactionSerializationError:
            return "Transaction Serialization Error"
        case .connectionError:
            return "Connection Error"
        case .dataError:
            return "Data Error"
        case .inputError(let desc):
            return desc
        case .nodeError(let desc):
            return desc
        case .processingError(let desc):
            return desc
        case .generalError(let err):
            return err.localizedDescription
        case .unknownError:
            return "Unknown Error"
        }
    }
}
