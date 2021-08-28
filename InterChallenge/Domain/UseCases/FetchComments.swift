import Foundation

protocol FetchComments {
    func fetch(postId: Int, callback: @escaping (Result<[Comment], DomainError>) -> Void)
}
