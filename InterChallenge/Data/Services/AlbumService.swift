import Foundation

protocol AlbumService {
    func fetchAlbums(userId: Int, callback: @escaping (Result<[Album], DomainError>)->Void)
}
