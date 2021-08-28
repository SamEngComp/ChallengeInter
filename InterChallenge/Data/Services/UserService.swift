import Foundation

protocol UserService {
    func fetchUsers(callback: @escaping (Result<[User], DomainError>) -> Void)
}
