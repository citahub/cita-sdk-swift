//
//  ETHMessageSigner.swift
//  Nervos
//
//  Created by XiaoLu on 2018/10/22.
//  Copyright © 2018 Cryptape. All rights reserved.
//

import Foundation

enum SignError: Error {
    case invalidPrivateKey
    case incorrectSignature
}

public struct ETHMessageSigner {
    public static func signPersonalMessage(message: Data, privateKey: String, useExtraEntropy: Bool = true) throws -> String? {
        return try sign(message: appendPersonalMessagePrefix(for: message), privateKey: privateKey, useExtraEntropy: useExtraEntropy)
    }

    public static func sign(message: Data, privateKey: String, useExtraEntropy: Bool = true) throws -> String? {
        return try signHash(hashMessage(message), privateKey: privateKey, useExtraEntropy: useExtraEntropy).toHexString().addHexPrefix()
    }

    public static func hashMessage(_ message: Data) -> Data {
        return message.sha3(.keccak256)
    }

    public static func hashPersonalMessage(_ personalMessage: Data) -> Data? {
        return hashMessage(appendPersonalMessagePrefix(for: personalMessage))
    }
}

private extension ETHMessageSigner {
    static func signHash(_ hash: Data, privateKey: String, useExtraEntropy: Bool) throws -> Data {
        guard let privateKeyData = Data.fromHex(privateKey) else {
            throw SignError.invalidPrivateKey
        }
        let serializedSignature = Secp256k1.signForRecovery(hash: hash, privateKey: privateKeyData, useExtraEntropy: useExtraEntropy).serializedSignature
        guard var signature = serializedSignature else {
            throw SignError.incorrectSignature
        }
        signature[64] += 27
        return signature
    }

    static func appendPersonalMessagePrefix(for message: Data) -> Data {
        let prefix = "\u{19}Ethereum Signed Message:\n\(message.count)"
        let prefixData = prefix.data(using: .ascii)!
        var data = Data()
        if message.count >= prefixData.count && prefixData == message[0 ..< prefixData.count] {
            data.append(message)
        } else {
            data.append(prefixData)
            data.append(message)
        }
        return data
    }
}
