//
//  MessageSigner.swift
//  AppChain
//
//  Created by XiaoLu on 2018/10/23.
//  Copyright © 2018 Cryptape. All rights reserved.
//

import Foundation

public enum SignError: Error {
    case invalidPrivateKey
    case invalidSignature
}

// AppChain Message Signer
struct MessageSigner {
    public init() {}

    // TODO: AppChain sign personal message
    public func sign(message: Data, privateKey: String, useExtraEntropy: Bool = true) throws -> String? {
        return try signHash(hashMessage(message), privateKey: privateKey, useExtraEntropy: useExtraEntropy).toHexString().addHexPrefix()
    }

    private func signHash(_ hash: Data, privateKey: String, useExtraEntropy: Bool = true) throws -> Data {
        guard let privateKeyData = Data.fromHex(privateKey) else {
            throw SignError.invalidPrivateKey
        }
        let serializedSignature = Secp256k1.signForRecovery(hash: hash, privateKey: privateKeyData, useExtraEntropy: useExtraEntropy).serializedSignature
        guard let signature = serializedSignature else {
            throw SignError.invalidSignature
        }
        return signature
    }

    public func hashMessage(_ message: Data) -> Data {
        return message.sha3(.keccak256)
    }

    public func hashPersonalMessage(_ personalMessage: Data) -> Data? {
        return hashMessage(appendPersonalMessagePrefix(for: personalMessage))
    }
}

extension MessageSigner {
    func appendPersonalMessagePrefix(for message: Data) -> Data {
        let prefix = "\u{19}Ethereum Signed Message:\n\(message.count)"
        let prefixData = prefix.data(using: .ascii)!
        if message.count >= prefixData.count && prefixData == message[0 ..< prefixData.count] {
            return message
        } else {
            return prefixData + message
        }
    }
}
