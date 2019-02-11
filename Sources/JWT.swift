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
        let headerPart = try encoder.encode(self.header).base64URLEncoded()
        let payloadPart =  try encoder.encode(self.payload).base64URLEncoded()

        let digest = "\(headerPart).\(payloadPart)"
        return digest
    }
}
