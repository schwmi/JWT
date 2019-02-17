import XCTest
@testable import JWT


final class ES256RawSignatureBuilderTests: XCTestCase {

    func testRawSignatureConstruction() {
        let asn1Signature = "MEQCICYOjVmJNJHb3dts08+DDBMBiPmW1qTDabJEtaVFeXbQAiB10ZBSXJICOvRC7eMr0MzbJaqWM6oMIjvUxVJBa/Z51w=="
        let data = Data(base64Encoded: asn1Signature)!
        let asn1 = try! ASN1DERDecoder().parseASN1(fromDER: data)
        let rawSignature = try? ES256RawSignatureBuilder(asn1Element: asn1).makeRawSignature()
        XCTAssertEqual(rawSignature?.count, 64)
        XCTAssertEqual(rawSignature?.base64EncodedString(), "Jg6NWYk0kdvd22zTz4MMEwGI+ZbWpMNpskS1pUV5dtB10ZBSXJICOvRC7eMr0MzbJaqWM6oMIjvUxVJBa/Z51w==")
    }
}
