import Foundation

protocol FetchPhotos {
    func fetch(albumId: Int, callback: @escaping (Result<[Photo], DomainError>) -> Void)
}
