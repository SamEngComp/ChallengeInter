import Foundation

protocol AlbumViewDelegate: class {
    func fillAlbums(albums: [Album])
    func errorPresent(error: DomainError)
}

protocol NextAlbumCoordinatorDelegate: class {
    func didEnterAlbum(with albumId: Int, by name: String)
}

class AlbumPresenter {
    private weak var viewDelegate: AlbumViewDelegate?
    private weak var coordinatorDelegate: NextAlbumCoordinatorDelegate?
    private let service: FetchAlbums
    
    init(service: FetchAlbums) {
        self.service = service
    }
    
    func setViewDelegate(viewDelegate: AlbumViewDelegate) {
        self.viewDelegate = viewDelegate
    }
    
    func setCoordinatorDelegate(coordinatorDelegate: NextAlbumCoordinatorDelegate) {
        self.coordinatorDelegate = coordinatorDelegate
    }
    
    func presetPhoto(albumId: Int, name: String) {
        coordinatorDelegate?.didEnterAlbum(with: albumId, by: name)
    }
    
    func getAllAlbums(userId: Int) {
        service.fetch(userId: userId) { result in
            switch result {
            case .success(let albums):
                self.viewDelegate?.fillAlbums(albums: albums)
            case .failure(let error):
                self.viewDelegate?.errorPresent(error: error)
            }
            
        }
    }
}
