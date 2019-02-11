import XCTest
@testable import JWT


final class SHA256HasherTests: XCTestCase {

    func testHashCreation() {
        guard let hash = try? SHA256Hasher().hash(from: "TestString") else {
            XCTFail("Expected a hash")
            return
        }

        let hex = hash.map { String(format: "%02X", $0) }.joined()
        // check with hash created at https://passwordsgenerator.net/sha256-hash-generator/
        XCTAssertEqual(hex, "6DD79F2770A0BB38073B814A5FF000647B37BE5ABBDE71EC9176C6CE0CB32A27")
    }
}
