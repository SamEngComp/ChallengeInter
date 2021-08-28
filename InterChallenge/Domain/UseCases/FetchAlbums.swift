import Foundation

protocol FetchAlbums {
    func fetch(userId: Int, callback: @escaping (Result<[Album], DomainError>) -> Void)
}
