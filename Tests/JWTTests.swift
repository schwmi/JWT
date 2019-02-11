


import XCTest
@testable import JWT

final class JWTTests: XCTestCase {

    func testTokenCreation() {
        let jwt = JWT(header: .init(keyIdentifier: "Test"),
                      payload: .init(issuerIdentifier: "ID", expirationTime: 0),
                      signer: ES256Signer(privateKey: "bla"))
        guard let token = try? jwt.makeToken() else {
            XCTFail("We should have a token here")
            return
        }

        // TODO check token
    }
}
