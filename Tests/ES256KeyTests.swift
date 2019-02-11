import XCTest
@testable import JWT


final class ES256KeyTests: XCTestCase {

    func testDERCreation() {
        let pemString = """
-----BEGIN EC PRIVATE KEY-----
MHcCAQEEIEne+ywDZxQ22PfrtUH3C0G4sLyfN8YE4MzetBp3yBFxoAoGCCqGSM49
AwEHoUQDQgAElNmmIbhSwJHJKQC9OyM5GZk+yGlHCOwH1sSBpzZNjKfTyWiV7ua0
ph1Vmrplh1QWv64YHloD4g+TZ7Q7UVYp6w==
-----END EC PRIVATE KEY-----
"""
        let es256Key = ES256Key(pemString: pemString)
        let der = es256Key.makeDERRepresentation().base64EncodedString()
        XCTAssertEqual(der, "AEne+ywDZxQ22PfrtUH3C0G4sLyfN8YE4MzetBp3yBFx")
    }
}
