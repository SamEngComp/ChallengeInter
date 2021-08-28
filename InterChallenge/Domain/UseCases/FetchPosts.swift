import Foundation

protocol FetchPosts {
    func fetch(userId: Int, callback: @escaping (Result<[Post], DomainError>) -> Void)
}
