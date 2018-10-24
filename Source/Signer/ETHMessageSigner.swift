//
//  ETHMessageSigner.swift
//  Nervos
//
//  Created by XiaoLu on 2018/10/22.
//  Copyright © 2018 Cryptape. All rights reserved.
//

import Foundation

enum SignerError: Error {
    case privateKeyIsNull
    case signatureIncorrect
    case messageSha3IsNull
    case addPrefixFailed
}

public struct ETHMessageSigner {
    public static func signPersonalMessage(message: Data, privateKey: String, useExtraEntropy: Bool = true) throws -> String? {
        guard let message = appendPersonalMessagePrefix(for: message) else {
            throw SignerError.addPrefixFailed
        }
        return try sign(message: message, privateKey: privateKey, useExtraEntropy: useExtraEntropy)
    }

    public static func sign(message: Data, privateKey: String, useExtraEntropy: Bool = true) throws -> String? {
        guard let hash = hashMessage(message) else {
            throw SignerError.messageSha3IsNull
        }
        return try signHash(hash, privateKey: privateKey, useExtraEntropy: useExtraEntropy).toHexString().addHexPrefix()
    }

    public static func hashMessage(_ message: Data) -> Data? {
        return message.sha3(.keccak256)
    }

    public static func hashPersonalMessage(_ personalMessage: Data) -> Data? {
        guard let message = appendPersonalMessagePrefix(for: personalMessage) else { return nil }
        return hashMessage(message)
    }
}

private extension ETHMessageSigner {
    static func signHash(_ hash: Data, privateKey: String, useExtraEntropy: Bool) throws -> Data {
        guard let privateKeyData = Data.fromHex(privateKey) else {
            throw SignerError.privateKeyIsNull
        }
        let serializedSignature = Secp256k1.signForRecovery(hash: hash, privateKey: privateKeyData, useExtraEntropy: useExtraEntropy).serializedSignature
        guard var signature = serializedSignature else {
            throw SignerError.signatureIncorrect
        }
        signature[64] += 27
        return signature
    }

    static func appendPersonalMessagePrefix(for message: Data) -> Data? {
        var prefix = "\u{19}Ethereum Signed Message:\n"
        prefix += String(message.count)
        guard let prefixData = prefix.data(using: .ascii) else { return nil }
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
