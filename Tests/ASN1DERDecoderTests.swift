import XCTest
@testable import JWT


final class ASN1DERDecoderTests: XCTestCase {

    func testDecodingOfRawDERSignature() {
        let signature = "MEUCIE_CUuy8-xhGorq41Sqb-09CUzzZGqyAtuAjqFqI1OMNAiEA0D8bGKj8IUguw-9k7epRhNCuB8nTeeeXA4jwUpdv8Rs"
        let signatureData = Data(base64URLEncodedString: signature)!
        do {
            let result = try ASN1DERDecoder().parseASN1(fromDER: signatureData)
            switch result {
            case .sequence(let elements):
                XCTAssertEqual(elements.count, 2)
            default:
                XCTFail("Expecting a sequence type")
            }
        } catch {
            XCTFail("Didn't expect a parsing error \(error)")
        }
    }
}
