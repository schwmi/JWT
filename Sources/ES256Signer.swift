import Foundation
import CCryptoBoringSSL


public final class ES256Signer {

    enum Error: Swift.Error {
        case signing
        case signatureCopy
        case keyCreation
        case signatureVerification
    }

    private let curve = NID_X9_62_prime256v1
    private let privateKey: [UInt8]

    // MARK: - Lifecycle

    public init(privateKey: ES256Key) {
        self.privateKey = [UInt8](privateKey.makeDERRepresentation())
    }

    public func sign(_ message: String) throws -> [UInt8] {
        var digest = try SHA256Hasher().hash(from: message)
        let ecKey = try newECKeyPair()

        guard let signature = CCryptoBoringSSL_ECDSA_do_sign(&digest, digest.count, ecKey) else {
            throw Error.signing
        }

        var derEncodedSignature: UnsafeMutablePointer<UInt8>? = nil
        let derLength = CCryptoBoringSSL_i2d_ECDSA_SIG(signature, &derEncodedSignature)

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
        let signature = CCryptoBoringSSL_d2i_ECDSA_SIG(nil, &signaturePointer, der.count)
        let ecKey = try self.newECKeyPair()
        let verified = CCryptoBoringSSL_ECDSA_do_verify(digest, digest.count, signature, ecKey)
        return verified == 1
    }
}

// MARK: - Private

private extension ES256Signer {

    func newECKey() throws -> OpaquePointer {
        guard let ecKey = CCryptoBoringSSL_EC_KEY_new_by_curve_name(self.curve) else {
            throw Error.keyCreation
        }
        return ecKey
    }

    func newECKeyPair() throws -> OpaquePointer {
        var privateNum = BIGNUM()

        // Set private key
        CCryptoBoringSSL_BN_init(&privateNum)
        CCryptoBoringSSL_BN_bin2bn(self.privateKey, self.privateKey.count, &privateNum)
        let ecKey = try newECKey()
        CCryptoBoringSSL_EC_KEY_set_private_key(ecKey, &privateNum)

        // Derive public key
        let context = CCryptoBoringSSL_BN_CTX_new()
        CCryptoBoringSSL_BN_CTX_start(context)

        let group = CCryptoBoringSSL_EC_KEY_get0_group(ecKey)
        let publicKey = CCryptoBoringSSL_EC_POINT_new(group)
        guard CCryptoBoringSSL_EC_POINT_mul(group, publicKey, &privateNum, nil, nil, context) == 1 else {
            throw Error.signing
        }
        guard CCryptoBoringSSL_EC_KEY_set_public_key(ecKey, publicKey) == 1 else {
            throw Error.signing
        }

        // Release resources
        CCryptoBoringSSL_EC_POINT_free(publicKey)
        CCryptoBoringSSL_BN_CTX_end(context)
        CCryptoBoringSSL_BN_CTX_free(context)
        CCryptoBoringSSL_BN_clear_free(&privateNum)

        return ecKey
    }
}
