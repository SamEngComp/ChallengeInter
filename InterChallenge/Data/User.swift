import Foundation

struct User: Codable {
    let id: Int
    let name: String
    let username: String
    let email: String
    let phone: String
    
    enum CodingKeys: String, CodingKey {
        case id, name, username, email, phone
    }
}
