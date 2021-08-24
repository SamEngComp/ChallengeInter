import Foundation

struct Comment: Codable {
    let id: Int
    let postId: Int
    let name: String
    let body: String
    
    enum CodingKeys: String, CodingKey {
        case id, postId, name, body
    }
}
