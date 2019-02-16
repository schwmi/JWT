import Foundation
import OpenSSL
final class ES256Signer {

    enum Error: Swift.Error {
        case signing
        case signatureCopy
        case keyCreation
        case publicKeyCreation
        case signatureVerification
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

    public func verifySignature(_ signature: String, message: String) throws -> Bool {
        guard let data = Data(base64URLEncodedString: signature) else {
            throw Error.signatureVerification
        }
        let der = [UInt8](data)
        let digest = try SHA256Hasher().hash(from: message)
        var signaturePointer: UnsafePointer? = UnsafePointer(der)
        let signature = d2i_ECDSA_SIG(nil, &signaturePointer, der.count)
        let ecKey = try self.newECKeyPair()
        let verified = ECDSA_do_verify(digest, Int32(digest.count), signature, ecKey)
        return verified == 1
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
        guard EC_POINT_mul(group, publicKey, &privateNum, nil, nil, context) == 1 else {
            throw Error.signing
        }
        guard EC_KEY_set_public_key(ecKey, publicKey) == 1 else {
            throw Error.signing
        }

        // Release resources
        EC_POINT_free(publicKey)
        BN_CTX_end(context)
        BN_CTX_free(context)
        BN_clear_free(&privateNum)

        return ecKey
    }
}
