import Foundation


extension Data {

    /// Creates `Data` from a hexadecimal string
    ///
    /// This creates a `Data` object from hex string. Note, if the string has any spaces or non-hex characters those are ignored
    init(hexString: String) {
        var data = Data(capacity: hexString.count / 2)

        let regex = try! NSRegularExpression(pattern: "[0-9a-f]{1,2}", options: .caseInsensitive)
        regex.enumerateMatches(in: hexString, options: [], range: NSMakeRange(0, hexString.count)) { match, flags, stop in
            let range = hexString.range(from: match!.range)
            let byteString = hexString[range!]
            var num = UInt8(byteString, radix: 16)
            data.append(&num!, count: 1)
        }

        self = data
    }

    /// Creates `Data` from a base64URLEncodedString string
    ///
    /// - Returns: A base64 encoded `String`.
    init?(base64URLEncodedString: String) {
        var base64 = base64URLEncodedString
            .replacingOccurrences(of: "-", with: "+")
            .replacingOccurrences(of: "_", with: "/")
        if base64.count % 4 != 0 {
            base64.append(String(repeating: "=", count: 4 - base64.count % 4))
        }
        self.init(base64Encoded: base64)
    }

    /// Encodes the data using base64.
    ///
    /// - Returns: A base64 encoded `String`.
    func base64URLEncodedString() -> String {
        return base64EncodedString()
            .replacingOccurrences(of: "=", with: "")
            .replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "/", with: "_")
    }
}

fileprivate extension String {

    func range(from nsRange: NSRange) -> Range<String.Index>? {
        guard let from16 = utf16.index(utf16.startIndex, offsetBy: nsRange.location, limitedBy: utf16.endIndex),
            let to16 = utf16.index(from16, offsetBy: nsRange.length, limitedBy: utf16.endIndex),
            let from = String.Index(from16, within: self),
            let to = String.Index(to16, within: self) else { return nil }
        return from ..< to
    }
}
