import Foundation
import OpenSSL


struct ES256Key {

    private let pemString: String

    // MARK: - Lifecycle

    init(pemString: String) {
        self.pemString = pemString
    }

    // MARK: - ES256Key

    func makeDERRepresentation() -> Data {
        let cString = self.pemString.cString(using: .utf8)!
        let bio = BIO_new_mem_buf(cString, Int32(cString.count))
        var key = EVP_PKEY_new()

        PEM_read_bio_PrivateKey(bio, &key, nil, nil)
        let ecKey = EVP_PKEY_get1_EC_KEY(key)
        let ecPKey = EC_KEY_get0_private_key(ecKey!)
        let pKeyBigNum = BN_bn2hex(ecPKey)!
        let pKeyHexString = "00" + String(validatingUTF8: pKeyBigNum)!
        let pKeyData = Data(hexString: pKeyHexString)

        EVP_PKEY_free(key)
        BIO_free(bio)

        return pKeyData
    }
}
