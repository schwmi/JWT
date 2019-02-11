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

        return "\(digest).\(Data(signature).base64URLEncodedString())"
    }
}
