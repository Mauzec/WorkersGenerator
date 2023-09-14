import Foundation

typealias NameData = [String]

struct AddressData: Codable {
    let addresses: [String]

    enum CodingKeys: String, CodingKey {
        case addresses = "Addresses"
    }
}
