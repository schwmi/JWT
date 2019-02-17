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
        case unhandledTag
    }

    enum Tag: UInt8 {
        case sequence = 0x30
        case integer = 0x02
    }

    indirect enum ASN1Element {
        case sequence([ASN1Element])
        case bytes(Data)
        case integer(Int64)
    }

    func parseASN1(fromDER data: Data) throws -> ASN1Element {
        guard data.count > 1 else { throw Error.malformed }

        var parsingData = data
        return try parsingData.parseASN1Element()
    }
}

// MARK: - Private

private extension Data {

    mutating func parseASN1Element() throws -> ASN1DERDecoder.ASN1Element {
        switch self.popFirst() {
        case ASN1DERDecoder.Tag.sequence.rawValue:
            let length = try self.parseLength()
            let remainingBytes = self.count - length
            var elements: [ASN1DERDecoder.ASN1Element] = []
            repeat {
                elements.append(try self.parseASN1Element())
            } while self.count > remainingBytes

            return .sequence(elements)
        case ASN1DERDecoder.Tag.integer.rawValue:
            let length = try self.parseLength()
            return try self.parseIntegerElementOfLength(length)
        default:
            throw ASN1DERDecoder.Error.unhandledTag
        }
    }

    mutating func parseIntegerElementOfLength(_ length: Int) throws -> ASN1DERDecoder.ASN1Element {
        if length < 8 {
            // fits into a Int64
            return .integer(try self.parseInt64OfLength(length))
        } else {
            // too large, return as bytes
            var bytes = Data()
            for _ in 0..<length {
                guard let byte = self.popFirst() else { throw ASN1DERDecoder.Error.malformed }

                bytes.append(byte)
            }
            return .bytes(bytes)
        }
    }

    mutating func parseLength() throws -> Int {
        guard let firstByte = self.popFirst() else { throw ASN1DERDecoder.Error.malformed }

        if firstByte.firstBitZero { // short form
            return Int(firstByte)
        } else {
            let byteCountOfLength = firstByte.lastSevenBits
            return try Int(self.parseInt64OfLength(Int(byteCountOfLength)))
        }
    }

    mutating func parseInt64OfLength(_ length: Int) throws -> Int64 {
        var result: Int64 = 0
        for _ in 0..<length {
            guard let byte = self.popFirst() else { throw ASN1DERDecoder.Error.malformed }

            result = 256 * result + Int64(byte)
        }
        return result
    }
}

private extension UInt8 {

    var firstBitZero: Bool {
        return self & 0x80 == 0x00
    }

    var lastSevenBits: UInt8 {
        return self & 0x7F
    }
}
