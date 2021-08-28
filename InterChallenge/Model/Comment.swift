import Foundation

struct Comment: Codable, Equatable {
    let id: Int
    let postId: Int
    let name: String
    let body: String
    
    enum CodingKeys: String, CodingKey {
        case id, postId, name, body
    }
}
