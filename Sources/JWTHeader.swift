import Foundation


/// JWT Header for the AppStore Connect Auth
struct Header: Codable {

    /// All JWTs for App Store Connect API must be signed with ES256 encryption
    let algorithm: String = "ES256"

    /// Your private key ID from App Store Connect (Ex: 2X9R4HXF34)
    let keyIdentifier: String

    /// The required type for signing requests to the App Store Connect API
    let tokenType: String = "JWT"

    enum CodingKeys: String, CodingKey {
        case algorithm = "alg"
        case keyIdentifier = "kid"
        case tokenType = "typ"
    }
}
