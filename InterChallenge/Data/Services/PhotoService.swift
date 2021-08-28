import Foundation

protocol PhotoService {
    func fetchPhotos(albumId: Int, callback: @escaping (Result<[Photo], DomainError>) -> Void)
}
