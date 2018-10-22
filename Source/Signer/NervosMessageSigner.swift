//
//  NervosMessageSigner.swift
//  Nervos
//
//  Created by XiaoLu on 2018/10/22.
//  Copyright © 2018 Cryptape. All rights reserved.
//

import Foundation
import secp256k1_swift

public struct NervosMessageSigner {
    enum Error: Swift.Error {
        case privateKeyIsNull
        case signatureIncorrect
        case messageSha3IsNull
        case addPrefixFailed
    }

    public static func signPersonalMessage(message: Data, privateKey: String, useExtraEntropy: Bool = true) throws -> String? {
        guard let message = Utils.appendPersonalMessagePrefix(for: message) else {
            throw Error.addPrefixFailed
        }
        return try sign(message: message, privateKey: privateKey, useExtraEntropy: useExtraEntropy)
    }

    public static func sign(message: Data, privateKey: String, useExtraEntropy: Bool = true) throws -> String? {
        guard let hash = Utils.hashMessage(message) else {
            throw Error.messageSha3IsNull
        }
        return try signHash(hash, privateKey: privateKey, useExtraEntropy: useExtraEntropy).toHexString().addHexPrefix()
    }

    private static func signHash(_ hash: Data, privateKey: String, useExtraEntropy: Bool = true) throws -> Data {
        guard let privateKeyData = Data.fromHex(privateKey) else {
            throw Error.privateKeyIsNull
        }
        let serializedSignature = SECP256K1.signForRecovery(hash: hash, privateKey: privateKeyData, useExtraEntropy: useExtraEntropy).serializedSignature
        guard let signature = serializedSignature else {
            throw Error.signatureIncorrect
        }
        return signature
    }
}
