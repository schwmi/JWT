import Foundation
import COpenSSL


final class SHA256Hasher {

    enum Error: Swift.Error {
        case updating
        case finalizing
    }

    func hash(from string: String) throws -> [UInt8] {
        return try self.hash(from: Data(string.utf8))
    }

    func hash(from data: Data) throws -> [UInt8] {
        var data = data
        var ctx = SHA256_CTX()
        SHA256_Init(&ctx)
        guard SHA256_Update(&ctx, [UInt8](data), data.count) == 1 else {
            throw Error.updating
        }

        var digest = [UInt8](repeating: 0, count: Int(SHA256_DIGEST_LENGTH))
        guard SHA256_Final(&digest, &ctx) == 1 else {
            throw Error.finalizing
        }
        return digest
    }
}
