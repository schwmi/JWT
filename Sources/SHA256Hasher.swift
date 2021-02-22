import Foundation
import Crypto


final class SHA256Hasher {

    enum Error: Swift.Error {
        case updating
        case finalizing
    }

    func hash(from string: String) throws -> [UInt8] {
        return try self.hash(from: Data(string.utf8))
    }

    func hash(from data: Data) throws -> [UInt8] {
        var sha256 = SHA256()
        sha256.update(data: data)
        let digest = sha256.finalize()

        return Array(digest)
    }
}
