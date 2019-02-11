import Foundation
import OpenSSL
final class ES256Signer {

    enum Error: Swift.Error {
        case signing
        case signatureCopy
        case keyCreation
        case publicKeyCreation
    }

    private let curve = NID_X9_62_prime256v1
    private let privateKey: [UInt8]

    // MARK: - Lifecycle

    init(privateKey: ES256Key) {
        self.privateKey = [UInt8](privateKey.makeDERRepresentation())
    }

    public func sign(_ message: String) throws -> [UInt8] {
        var digest = try SHA256Hasher().hash(from: message)
        let ecKey = try newECKeyPair()

        guard let signature = ECDSA_do_sign(&digest, Int32(digest.count), ecKey) else {
            throw Error.signing
        }

        var derEncodedSignature: UnsafeMutablePointer<UInt8>? = nil
        let derLength = i2d_ECDSA_SIG(signature, &derEncodedSignature)

        guard let derCopy = derEncodedSignature, derLength > 0 else {
            throw Error.signatureCopy
        }

        var derBytes = [UInt8](repeating: 0, count: Int(derLength))

        for b in 0..<Int(derLength) {
            derBytes[b] = derCopy[b]
        }

        return derBytes
    }
}

// MARK: - Private

private extension ES256Signer {

    func newECKey() throws -> OpaquePointer {
        guard let ecKey = EC_KEY_new_by_curve_name(self.curve) else {
            throw Error.keyCreation
        }
        return ecKey
    }

    func newECKeyPair() throws -> OpaquePointer {
        var privateNum = BIGNUM()

        // Set private key
        BN_init(&privateNum)
        BN_bin2bn(self.privateKey, Int32(self.privateKey.count), &privateNum)
        let ecKey = try newECKey()
        EC_KEY_set_private_key(ecKey, &privateNum)

        // Derive public key
        let context = BN_CTX_new()
        BN_CTX_start(context)

        let group = EC_KEY_get0_group(ecKey)
        let publicKey = EC_POINT_new(group)
        EC_POINT_mul(group, publicKey, &privateNum, nil, nil, context)
        EC_KEY_set_public_key(ecKey, publicKey)

        // Release resources
        EC_POINT_free(publicKey)
        BN_CTX_end(context)
        BN_CTX_free(context)
        BN_clear_free(&privateNum)

        return ecKey
    }

    func newECPublicKey() throws -> OpaquePointer {
        var ecKey: OpaquePointer? = try newECKey()
        var publicBytesPointer: UnsafePointer? = UnsafePointer<UInt8>(self.privateKey)

        if let ecKey = o2i_ECPublicKey(&ecKey, &publicBytesPointer, self.privateKey.count) {
            return ecKey
        } else {
            throw Error.publicKeyCreation
        }
    }
}
