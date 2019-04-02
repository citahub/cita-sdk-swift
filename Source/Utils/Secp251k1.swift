import Foundation
import secp256k1
import BigInt

func toByteArray<T>(_ value: T) -> [UInt8] {
    var value = value
    return withUnsafeBytes(of: &value) { Array($0) }
}

extension Data {
    func checkSignatureSize() throws {
        try checkSignatureSize(compressed: false)
    }

    func checkSignatureSize(compressed: Bool) throws {
        if compressed {
            guard count == 33 else { throw Secp256k1Error.invalidSignatureSize }
        } else {
            guard count == 65 else { throw Secp256k1Error.invalidSignatureSize }
        }
    }

    func checkSignatureSize(maybeCompressed: Bool) throws {
        if maybeCompressed {
            guard count == 65 || count == 33 else { throw Secp256k1Error.invalidSignatureSize }
        } else {
            guard count == 65 else { throw Secp256k1Error.invalidSignatureSize }
        }
    }

    func checkHashSize() throws {
        guard count == 32 else { throw Secp256k1Error.invalidHashSize }
    }

    func checkPrivateKeySize() throws {
        guard count == 32 else { throw Secp256k1Error.invalidPrivateKeySize }
    }

    func checkPublicKeySize() throws {
        guard count == 65 else { throw Secp256k1Error.invalidPublicKeySize }
    }
}

public struct Secp256k1 {
    public struct UnmarshaledSignature {
        var v: UInt8
        var r = [UInt8](repeating: 0, count: 32)
        var s = [UInt8](repeating: 0, count: 32)
    }
}

extension Secp256k1 {
    static var context = secp256k1_context_create(UInt32(SECP256K1_CONTEXT_SIGN | SECP256K1_CONTEXT_VERIFY))

    // throws Secp256k1Error
    static func signForRecovery(hash: Data, privateKey: Data, useExtraEntropy: Bool = false) throws -> (serializedSignature: Data, rawSignature: Data) {
        try hash.checkHashSize()
        try Secp256k1.verifyPrivateKey(privateKey: privateKey)

        var recoverableSignature = try Secp256k1.recoverableSign(hash: hash, privateKey: privateKey, useExtraEntropy: useExtraEntropy)
        let truePublicKey = try Secp256k1.privateKeyToPublicKey(privateKey: privateKey)
        let recoveredPublicKey = try Secp256k1.recoverPublicKey(hash: hash, recoverableSignature: &recoverableSignature)

        if Data(toByteArray(truePublicKey.data)) != Data(toByteArray(recoveredPublicKey.data)) {
            throw Secp256k1Error.signingFailed
        }
        let serializedSignature = try Secp256k1.serializeSignature(recoverableSignature: &recoverableSignature)
        let rawSignature = Data(toByteArray(recoverableSignature))
        return (serializedSignature, rawSignature)
    }

    static func privateToPublic(privateKey: Data, compressed: Bool = false) throws -> Data {
        var publicKey = try Secp256k1.privateKeyToPublicKey(privateKey: privateKey)
        return try serializePublicKey(publicKey: &publicKey, compressed: compressed)
    }

    static func combineSerializedPublicKeys(keys: [Data], outputCompressed: Bool = false) throws -> Data {
        assert(!keys.isEmpty, "Combining 0 public keys")
        let numToCombine = keys.count
        var storage = ContiguousArray<secp256k1_pubkey>()
        let arrayOfPointers = UnsafeMutablePointer<UnsafePointer<secp256k1_pubkey>?>.allocate(capacity: numToCombine)
        defer {
            arrayOfPointers.deinitialize(count: numToCombine)
            arrayOfPointers.deallocate()
        }
        for i in 0 ..< numToCombine {
            let key = keys[i]
            let pubkey = try Secp256k1.parsePublicKey(serializedKey: key)
            storage.append(pubkey)
        }
        for i in 0 ..< numToCombine {
            withUnsafePointer(to: &storage[i]) { (ptr) -> Void in
                arrayOfPointers.advanced(by: i).pointee = ptr
            }
        }
        let immutablePointer = UnsafePointer(arrayOfPointers)
        var publicKey = secp256k1_pubkey()

        let result = withUnsafeMutablePointer(to: &publicKey) { (pubKeyPtr: UnsafeMutablePointer<secp256k1_pubkey>) -> Int32 in
            let res = secp256k1_ec_pubkey_combine(context!, pubKeyPtr, immutablePointer, numToCombine)
            return res
        }
        guard result != 0 else { throw Secp256DataError.cannotCombinePublicKeys }
        return try Secp256k1.serializePublicKey(publicKey: &publicKey, compressed: outputCompressed)
    }

    static func recoverPublicKey(hash: Data, recoverableSignature: inout secp256k1_ecdsa_recoverable_signature) throws -> secp256k1_pubkey {
        try hash.checkHashSize()
        var publicKey: secp256k1_pubkey = secp256k1_pubkey()
        let result = hash.withUnsafeBytes { (hash: UnsafeRawBufferPointer) -> Int32 in
            withUnsafePointer(to: &recoverableSignature, { (signaturePointer: UnsafePointer<secp256k1_ecdsa_recoverable_signature>) in
                withUnsafeMutablePointer(to: &publicKey, { (pubKeyPtr: UnsafeMutablePointer<secp256k1_pubkey>) in
                    let hashPointer = hash.baseAddress!.assumingMemoryBound(to: UInt8.self)
                    return secp256k1_ecdsa_recover(context!, pubKeyPtr, signaturePointer, hashPointer)
                })
            })
        }
        guard result != 0 else { throw Secp256DataError.cannotRecoverPublicKey }
        return publicKey
    }

    static func privateKeyToPublicKey(privateKey: Data) throws -> secp256k1_pubkey {
        try privateKey.checkPrivateKeySize()
        var publicKey = secp256k1_pubkey()
        let result = privateKey.withUnsafeBytes { (pk: UnsafeRawBufferPointer) -> Int32 in
            let privateKeyPointer = pk.baseAddress!.assumingMemoryBound(to: UInt8.self)
            return secp256k1_ec_pubkey_create(context!, &publicKey, privateKeyPointer)
        }
        guard result != 0 else { throw Secp256DataError.cannotExtractPublicKeyFromPrivateKey }
        return publicKey
    }

    static func serializePublicKey(publicKey: inout secp256k1_pubkey, compressed: Bool = false) throws -> Data {
        var keyLength = compressed ? 33 : 65
        var serializedPubkey = Data(repeating: 0x00, count: keyLength)
        let flags = UInt32(compressed ? SECP256K1_EC_COMPRESSED : SECP256K1_EC_UNCOMPRESSED)
        let result = serializedPubkey.withUnsafeMutableBytes { (serializedPubkey: UnsafeMutableRawBufferPointer) -> Int32 in
            withUnsafeMutablePointer(to: &keyLength, { (keyPtr: UnsafeMutablePointer<Int>) in
                withUnsafeMutablePointer(to: &publicKey, { (pubKeyPtr: UnsafeMutablePointer<secp256k1_pubkey>) in
                    let serializedPubkeyPointer = serializedPubkey.baseAddress!.assumingMemoryBound(to: UInt8.self)
                    return secp256k1_ec_pubkey_serialize(context!, serializedPubkeyPointer, keyPtr, pubKeyPtr, flags)
                })
            })
        }
        guard result != 0 else { throw Secp256DataError.cannotSerializePublicKey }
        return Data(serializedPubkey)
    }

    static func parsePublicKey(serializedKey: Data) throws -> secp256k1_pubkey {
        try serializedKey.checkSignatureSize(maybeCompressed: true)
        let keyLen: Int = Int(serializedKey.count)
        var publicKey = secp256k1_pubkey()
        let result = serializedKey.withUnsafeBytes { (serializedKey: UnsafeRawBufferPointer) -> Int32 in
            let serializedKeyPointer = serializedKey.baseAddress!.assumingMemoryBound(to: UInt8.self)
            return secp256k1_ec_pubkey_parse(context!, &publicKey, serializedKeyPointer, keyLen)
        }
        guard result != 0 else { throw Secp256DataError.cannotParsePublicKey }
        return publicKey
    }

    static func parseSignature(signature: Data) throws -> secp256k1_ecdsa_recoverable_signature {
        try signature.checkSignatureSize()
        var recoverableSignature = secp256k1_ecdsa_recoverable_signature()
        let serializedSignature = Data(signature[0 ..< 64])
        var v = Int32(signature[64])

        /*
         fix for web3.js signs
         eth-lib code: vrs.v < 2 ? vrs.v : 1 - (vrs.v % 2)
         https://github.com/MaiaVictor/eth-lib/blob/d959c54faa1e1ac8d474028ed1568c5dce27cc7a/src/account.js#L60
         */
        v = v < 2 ? v : 1 - (v % 2)
        let result = serializedSignature.withUnsafeBytes { (ser: UnsafeRawBufferPointer) -> Int32 in
            withUnsafeMutablePointer(to: &recoverableSignature, { (signaturePointer: UnsafeMutablePointer<secp256k1_ecdsa_recoverable_signature>) in
                let serPointer = ser.baseAddress!.assumingMemoryBound(to: UInt8.self)
                return secp256k1_ecdsa_recoverable_signature_parse_compact(context!, signaturePointer, serPointer, v)
            })
        }
        guard result != 0 else { throw Secp256DataError.cannotParseSignature }
        return recoverableSignature
    }

    static func serializeSignature(recoverableSignature: inout secp256k1_ecdsa_recoverable_signature) throws -> Data {
        var serializedSignature = Data(repeating: 0x00, count: 64)
        var v: Int32 = 0
        let result = serializedSignature.withUnsafeMutableBytes { (serSignature: UnsafeMutableRawBufferPointer) -> Int32 in
            withUnsafePointer(to: &recoverableSignature) { (signaturePointer: UnsafePointer<secp256k1_ecdsa_recoverable_signature>) in
                withUnsafeMutablePointer(to: &v, { (vPtr: UnsafeMutablePointer<Int32>) in
                    let serSignaturePointer = serSignature.baseAddress!.assumingMemoryBound(to: UInt8.self)
                    return secp256k1_ecdsa_recoverable_signature_serialize_compact(context!, serSignaturePointer, vPtr, signaturePointer)
                })
            }
        }
        guard result != 0 else { throw Secp256DataError.cannotSerializeSignature }
        if v == 0 {
            serializedSignature.append(0x00)
        } else if v == 1 {
            serializedSignature.append(0x01)
        } else {
            throw Secp256DataError.cannotSerializeSignature
        }
        return Data(serializedSignature)
    }

    static func recoverableSign(hash: Data, privateKey: Data, useExtraEntropy: Bool = true) throws -> secp256k1_ecdsa_recoverable_signature {
        try hash.checkHashSize()
        try Secp256k1.verifyPrivateKey(privateKey: privateKey)
        var recoverableSignature: secp256k1_ecdsa_recoverable_signature = secp256k1_ecdsa_recoverable_signature()
        let extraEntropy = Data.randomBytes(length: 32)
        let result = hash.withUnsafeBytes { (hash: UnsafeRawBufferPointer) -> Int32 in
            privateKey.withUnsafeBytes { (privateKey: UnsafeRawBufferPointer) in
                extraEntropy!.withUnsafeBytes { (extraEntropy: UnsafeRawBufferPointer) in
                    withUnsafeMutablePointer(to: &recoverableSignature, { (recSignaturePtr: UnsafeMutablePointer<secp256k1_ecdsa_recoverable_signature>) in
                        let hashPointer = hash.baseAddress!.assumingMemoryBound(to: UInt8.self)
                        let privateKeyPointer = privateKey.baseAddress!.assumingMemoryBound(to: UInt8.self)
                        let extraEntropyPointer = extraEntropy.baseAddress!.assumingMemoryBound(to: UInt8.self)
                        return secp256k1_ecdsa_sign_recoverable(context!, recSignaturePtr, hashPointer, privateKeyPointer, nil, useExtraEntropy ? extraEntropyPointer : nil)
                    })
                }
            }
        }
        guard result != 0 else { throw Secp256DataError.cannotMakeRecoverableSignature }
        return recoverableSignature
    }

    static func recoverPublicKey(hash: Data, signature: Data, compressed: Bool = false) throws -> Data {
        var recoverableSignature = try parseSignature(signature: signature)
        var publicKey = try Secp256k1.recoverPublicKey(hash: hash, recoverableSignature: &recoverableSignature)
        return try Secp256k1.serializePublicKey(publicKey: &publicKey, compressed: compressed)
    }

    static func verifyPrivateKey(privateKey: Data) throws {
        try privateKey.checkPrivateKeySize()
        let result = privateKey.withUnsafeBytes { (privateKey: UnsafeRawBufferPointer) -> Int32 in
            let privateKeyPointer = privateKey.baseAddress!.assumingMemoryBound(to: UInt8.self)
            return secp256k1_ec_seckey_verify(context!, privateKeyPointer)
        }
        guard result == 1 else { throw Secp256k1Error.invalidPrivateKey }
    }

    static func unmarshalSignature(signatureData: Data) throws -> UnmarshaledSignature {
        try signatureData.checkSignatureSize()
        let bytes = signatureData.bytes
        let r = Array(bytes[0 ..< 32])
        let s = Array(bytes[32 ..< 64])
        var v = bytes[64]
        if v >= 27 {
            v -= 27
        }
        guard v <= 3 else { throw Secp256DataError.signatureCorrupted }
        return UnmarshaledSignature(v: v, r: r, s: s)
    }

    static func marshalSignature(v: UInt8, r: [UInt8], s: [UInt8]) throws -> Data {
        guard r.count == 32, s.count == 32 else { throw Secp256DataError.invalidMarshalSignatureSize }
        var completeSignature = Data(r)
        completeSignature.append(Data(s))
        completeSignature.append(Data([v]))
        return completeSignature
    }

    static func marshalSignature(v: Data, r: Data, s: Data) throws -> Data {
        guard r.count == 32, s.count == 32, v.count == 1 else { throw Secp256DataError.invalidMarshalSignatureSize }
        var completeSignature = Data(r)
        completeSignature.append(s)
        completeSignature.append(v)
        return completeSignature
    }
}
