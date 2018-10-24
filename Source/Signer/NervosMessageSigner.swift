//
//  NervosMessageSigner.swift
//  Nervos
//
//  Created by XiaoLu on 2018/10/23.
//  Copyright © 2018 Cryptape. All rights reserved.
//

import Foundation
import secp256k1_swift

struct NervosMessageSigner {
    // TODO: Nervos sign personal message
    public static func sign(message: Data, privateKey: String, useExtraEntropy: Bool = true) throws -> String? {
        return try signHash(ETHMessageSigner.hashMessage(message), privateKey: privateKey, useExtraEntropy: useExtraEntropy).toHexString().addHexPrefix()
    }

    private static func signHash(_ hash: Data, privateKey: String, useExtraEntropy: Bool = true) throws -> Data {
        guard let privateKeyData = Data.fromHex(privateKey) else {
            throw SignError.invalidPrivateKey
        }
        let serializedSignature = SECP256K1.signForRecovery(hash: hash, privateKey: privateKeyData, useExtraEntropy: useExtraEntropy).serializedSignature
        guard let signature = serializedSignature else {
            throw SignError.incorrectSignature
        }
        return signature
    }
}
