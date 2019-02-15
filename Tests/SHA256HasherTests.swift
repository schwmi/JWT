import XCTest
@testable import JWT


final class SHA256HasherTests: XCTestCase {

    func testHashCreation() {
        do {
            guard let hash = try? SHA256Hasher().hash(from: "TestString") else {
                XCTFail("Expected a hash")
                return
            }

            let hex = hash.map { String(format: "%02X", $0) }.joined()
            // check with hash created at https://passwordsgenerator.net/sha256-hash-generator/
            XCTAssertEqual(hex, "6DD79F2770A0BB38073B814A5FF000647B37BE5ABBDE71EC9176C6CE0CB32A27")
        }

        do {
            let digest = "eyJhbGciOiJFUzI1NiIsImtpZCI6IjI3S1hQWEs5WlAiLCJ0eXAiOiJKV1QifQ.eyJpc3MiOiI2OWE2ZGU5OC0zNDYyLTQ3ZTMtZTA1My01YjhjN2MxMWE0ZDEiLCJleHAiOjE1NTAyNjIxNzEuMzc1NjAzLCJhdWQiOiJhcHBzdG9yZWNvbm5lY3QtdjEifQ"
            guard let hash = try? SHA256Hasher().hash(from: digest) else {
                XCTFail("Expected a hash")
                return
            }
            let base64Hash = Data(hash).base64EncodedString()
            XCTAssertEqual(base64Hash, "7bffigO0Ivy7PwlbHpVHPjenrDfzg3354xJA2CIHcww=")
        }
    }
}
