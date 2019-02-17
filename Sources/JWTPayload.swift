import Foundation


public struct Payload: Codable {
    /// Your issuer identifier from the API Keys page in App Store Connect (Ex: 57246542-96fe-1a63-e053-0824d011072a)
    let issuerIdentifier: String

    /// The token's expiration time, in Unix epoch time; tokens that expire more than 20 minutes in the future are not valid (Ex: 1528408800)
    let expirationTime: TimeInterval

    /// The required audience which is set to the App Store Connect version.
    let audience: String = "appstoreconnect-v1"

    enum CodingKeys: String, CodingKey {
        case issuerIdentifier = "iss"
        case expirationTime = "exp"
        case audience = "aud"
    }

    init(issuerIdentifier: String, expirationTime: TimeInterval) {
        self.issuerIdentifier = issuerIdentifier
        self.expirationTime = expirationTime
    }
}
