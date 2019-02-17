import Foundation


struct ES256RawSignatureBuilder {

    enum Error: Swift.Error {
        case malformed
    }

    private let asn1Element: ASN1DERDecoder.ASN1Element

    // MARK: - Lifecycle

    init(asn1Element: ASN1DERDecoder.ASN1Element) {
        self.asn1Element = asn1Element
    }

    // MARK: ES256RawSignature

    func makeRawSignature() throws -> Data {
        guard case let ASN1DERDecoder.ASN1Element.sequence(elements) = asn1Element else { throw Error.malformed }
        guard elements.count == 2 else { throw Error.malformed }
        guard case var ASN1DERDecoder.ASN1Element.bytes(sigR) = elements[0] else { throw Error.malformed }
        guard case var ASN1DERDecoder.ASN1Element.bytes(sigS) = elements[1] else { throw Error.malformed }

        func dropPotentialLeadingZeroByte(of bytes: inout Data) {
            guard bytes.count == 33 else { return }
            guard bytes.first == 0x0 else { return }

            bytes.removeFirst()
        }

        dropPotentialLeadingZeroByte(of: &sigR)
        dropPotentialLeadingZeroByte(of: &sigS)
        return sigR + sigS
    }
}
