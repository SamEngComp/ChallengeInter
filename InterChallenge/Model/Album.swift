import Foundation

struct Album: Codable, Equatable {
    let id: Int
    let userId: Int
    let title: String
    
    enum CodingKeys: String, CodingKey {
        case id, userId, title
    }
}
