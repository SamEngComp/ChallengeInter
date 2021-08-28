import Foundation

protocol FetchUsers {
    func fetch(callback: @escaping (Result<[User], DomainError>) -> Void)
}
