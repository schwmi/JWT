//
//  ES256Signer.swift
//  JWT
//
//  Created by Michael Schwarz on 11.02.19.
//

import Foundation
import OpenSSL
final class ES256Signer {

    private let curve = NID_X9_62_prime256v1
    private let privateKey: String

    // MARK: - Lifecycle

    init(privateKey: String) {
        self.privateKey = privateKey
    }

    public func sign(_ message: String) throws -> [UInt8] {
        return []
    }
}
