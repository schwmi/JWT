//
//  ES256Signer.swift
//  JWT
//
//  Created by Michael Schwarz on 11.02.19.
//

import Foundation


final class ES256Signer {

    private let privateKey: String

    init(privateKey: String) {
        self.privateKey = privateKey
    }
}
