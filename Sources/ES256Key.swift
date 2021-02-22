import Foundation
import CCryptoBoringSSL


public struct ES256Key {

    private let pemString: String

    // MARK: - Lifecycle

    public init(pemString: String) {
        self.pemString = pemString
    }

    // MARK: - ES256Key

    func makeDERRepresentation() -> Data {
        let cString = self.pemString.cString(using: .utf8)!
        let bio = CCryptoBoringSSL_BIO_new_mem_buf(cString, Int32(cString.count))
        var key = CCryptoBoringSSL_EVP_PKEY_new()

        CCryptoBoringSSL_PEM_read_bio_PrivateKey(bio, &key, nil, nil)
        let ecKey = CCryptoBoringSSL_EVP_PKEY_get1_EC_KEY(key)
        CCryptoBoringSSL_EC_KEY_set_conv_form(ecKey, POINT_CONVERSION_UNCOMPRESSED)
        let ecPKey = CCryptoBoringSSL_EC_KEY_get0_private_key(ecKey!)
        let pKeyBigNum = CCryptoBoringSSL_BN_bn2hex(ecPKey)!
        let pKeyHexString = "00" + String(validatingUTF8: pKeyBigNum)!
        let pKeyData = Data(hexString: pKeyHexString)

        CCryptoBoringSSL_EVP_PKEY_free(key)
        CCryptoBoringSSL_BIO_free(bio)

        return pKeyData
    }
}
