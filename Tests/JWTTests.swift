import XCTest
@testable import JWT

final class JWTTests: XCTestCase {

    func testTokenCreation() {
        let privateKeyPem = """
-----BEGIN EC PRIVATE KEY-----
MHcCAQEEIEne+ywDZxQ22PfrtUH3C0G4sLyfN8YE4MzetBp3yBFxoAoGCCqGSM49
AwEHoUQDQgAElNmmIbhSwJHJKQC9OyM5GZk+yGlHCOwH1sSBpzZNjKfTyWiV7ua0
ph1Vmrplh1QWv64YHloD4g+TZ7Q7UVYp6w==
-----END EC PRIVATE KEY-----
"""
        let privateKey = ES256Key(pemString: privateKeyPem)
        let jwt = JWT(header: .init(keyIdentifier: "Test"),
                      payload: .init(issuerIdentifier: "ID", expirationTime: 0),
                      signer: ES256Signer(privateKey: privateKey))
        guard let token = try? jwt.makeToken() else {
            XCTFail("We should have a token here")
            return
        }

        // check if token is well-formed
        let components = token.components(separatedBy: ".")
        XCTAssertEqual(components.count, 3)

        // check if digest is correct encoded
        let digest = components.dropLast().joined(separator: ".")
        XCTAssertEqual(digest, "eyJhbGciOiJFUzI1NiIsImtpZCI6IlRlc3QiLCJ0eXAiOiJKV1QifQ.eyJpc3MiOiJJRCIsImV4cCI6MCwiYXVkIjoiYXBwc3RvcmVjb25uZWN0LXYxIn0")
    }
}
