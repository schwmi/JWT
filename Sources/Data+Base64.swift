import Foundation


extension Data {

    /// Encodes the data using base64.
    ///
    /// - Returns: A base64 encoded `String`.
    func base64URLEncoded() -> String {
        return base64EncodedString()
            .replacingOccurrences(of: "=", with: "")
            .replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "/", with: "_")
    }
}
