import Foundation


struct JWT {

    let header: Header
    let payload: Payload
    let signer: ES256Signer

    init(header: Header, payload: Payload, signer: ES256Signer) {
        self.header = header
        self.payload = payload
        self.signer = signer
    }

    func makeToken() throws -> String {
        let encoder = JSONEncoder()
        let headerPart = try encoder.encode(self.header).base64URLEncodedString()
        let payloadPart =  try encoder.encode(self.payload).base64URLEncodedString()

        let digest = "\(headerPart).\(payloadPart)"

        let signature = try self.signer.sign(digest)

        let asn1 = try ASN1DERDecoder().parseASN1(fromDER: Data(signature))
        let rawSignature = try ES256RawSignatureBuilder(asn1Element: asn1).makeRawSignature()
        return "\(digest).\(rawSignature.base64URLEncodedString())"
    }
}
