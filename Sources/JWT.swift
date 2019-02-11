


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
        return ""
    }
}
