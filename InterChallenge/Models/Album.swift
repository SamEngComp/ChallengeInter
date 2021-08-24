import Foundation

struct Album: Codable {
    let id: Int
    let userId: Int
    let title: String
    
    enum CodingKeys: String, CodingKey {
        case id, userId, title
    }
}
