//
//  MessageSigner.swift
//  CITA
//
//  Created by XiaoLu on 2018/10/23.
//  Copyright © 2018 Cryptape. All rights reserved.
//

import Foundation

public enum SignError: Error {
    case invalidPrivateKey
    case invalidSignature
}

// CITA Message Signer
public struct MessageSigner {
    public init() {}

    public func sign(message: Data, privateKey: String, useExtraEntropy: Bool = true) throws -> String? {
        return try signHash(hashMessage(message), privateKey: privateKey, useExtraEntropy: useExtraEntropy).toHexString().addHexPrefix()
    }

    public func hashMessage(_ message: Data) -> Data {
        return message.sha3(.keccak256)
    }

    private func signHash(_ hash: Data, privateKey: String, useExtraEntropy: Bool = true) throws -> Data {
        guard let privateKeyData = Data.fromHex(privateKey) else {
            throw SignError.invalidPrivateKey
        }
        let serializedSignature = try? Secp256k1.signForRecovery(hash: hash, privateKey: privateKeyData, useExtraEntropy: useExtraEntropy).serializedSignature
        guard let signature = serializedSignature else {
            throw SignError.invalidSignature
        }
        return signature
    }
}
