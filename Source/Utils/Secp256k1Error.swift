//
//  Secp256k1Error.swift
//  CITA
//
//  Created by XiaoLu on 2019/4/2.
//  Copyright © 2019 Cryptape. All rights reserved.
//

import Foundation

/// Errors for secp256k1
public enum Secp256k1Error: Error {
    /// Signature failed
    case signingFailed
    /// Cannot verify private key
    case invalidPrivateKey
    /// Hash size should be 32 bytes long
    case invalidHashSize
    /// Private key size should be 32 bytes long
    case invalidPrivateKeySize
    /// Signature size should be 65 bytes long
    case invalidSignatureSize
    /// Public key size should be 65 bytes long
    case invalidPublicKeySize
    /// Printable / user displayable description
    public var localizedDescription: String {
        switch self {
        case .signingFailed:
            return "Signature failed"
        case .invalidPrivateKey:
            return "Cannot verify private key"
        case .invalidHashSize:
            return "Hash size should be 32 bytes long"
        case .invalidPrivateKeySize:
            return "Private key size should be 32 bytes long"
        case .invalidSignatureSize:
            return "Signature size should be 65 bytes long"
        case .invalidPublicKeySize:
            return "Public key size should be 65 bytes long"
        }
    }
}

public enum Secp256DataError: Error {
    /// Cannot recover public key
    case cannotRecoverPublicKey
    /// Cannot extract public key from private key
    case cannotExtractPublicKeyFromPrivateKey
    /// Cannot make recoverable signature
    case cannotMakeRecoverableSignature
    /// Cannot parse signature
    case cannotParseSignature
    /// Cannot parse public key
    case cannotParsePublicKey
    /// Cannot serialize public key
    case cannotSerializePublicKey
    /// Cannot combine public keys
    case cannotCombinePublicKeys
    /// Cannot serialize signature
    case cannotSerializeSignature
    /// Signature corrupted
    case signatureCorrupted
    /// Invalid marshal signature size
    case invalidMarshalSignatureSize
    /// Printable / user displayable description
    public var localizedDescription: String {
        switch self {
        case .cannotRecoverPublicKey:
            return "Cannot recover public key"
        case .cannotExtractPublicKeyFromPrivateKey:
            return "Cannot extract public key from private key"
        case .cannotMakeRecoverableSignature:
            return "Cannot make recoverable signature"
        case .cannotParseSignature:
            return "Cannot parse signature"
        case .cannotParsePublicKey:
            return "Cannot parse public key"
        case .cannotSerializePublicKey:
            return "Cannot serialize public key"
        case .cannotCombinePublicKeys:
            return "Cannot combine public keys"
        case .cannotSerializeSignature:
            return "Cannot serialize signature"
        case .signatureCorrupted:
            return "Signature corrupted"
        case .invalidMarshalSignatureSize:
            return "Invalid marshal signature size"
        }
    }
}
