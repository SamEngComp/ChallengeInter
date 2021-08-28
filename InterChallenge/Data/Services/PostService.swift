import Foundation

protocol PostService {
    func fetchPosts(userId: Int, callback: @escaping (Result<[Post], DomainError>) -> Void)
}
