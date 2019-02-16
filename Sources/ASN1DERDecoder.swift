//
//  ASN1Decoder.swift
//  JWT
//
//  Created by Michael Schwarz on 16.02.19.
//

import Foundation


// Decodes a DER encoded data into a ASN.1 structure
final class ASN1DERDecoder {

    enum Error: Swift.Error {
        case malformed
    }

    enum Tag: UInt8 {
        case sequence = 0x30
        case integer = 0x02
    }

    indirect enum ASN1Element {
        case sequence([ASN1Element])
        case bytes(Data)
        case integer(Int)
    }

    func parseASN1(fromDER data: Data) throws -> ASN1Element {
        guard data.count > 1 else { throw Error.malformed }

        switch data[0] {
        case Tag.sequence.rawValue:
            print("is sequence")
            break
        case Tag.integer.rawValue:
            print("is integer")
            break
        default:
            break
        }
        return ASN1Element.integer(0)
    }
}
