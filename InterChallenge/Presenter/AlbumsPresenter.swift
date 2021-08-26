import Foundation

protocol AlbumViewDelegate: NSObjectProtocol {
    func fillAlbums(albums: [Album]?)
}

protocol NextAlbumCoordinatorDelegate: class {
    func didEnterAlbum(with algumId: Int, by name: String)
}

class AlbumsPresenter {
    private weak var viewDelegate: AlbumViewDelegate?
    private weak var coordinatorDelegate: NextAlbumCoordinatorDelegate?
    private let service: AlbumService
    
    init(service: AlbumService) {
        self.service = service
    }
    
    func setViewDelegate(viewDelegate: AlbumViewDelegate) {
        self.viewDelegate = viewDelegate
    }
    
    func setCoordinatorDelegate(coordinatorDelegate: NextAlbumCoordinatorDelegate) {
        self.coordinatorDelegate = coordinatorDelegate
    }
    
    func presetPhoto(albumId: Int, userName: String) {
        coordinatorDelegate?.didEnterAlbum(with: albumId, by: userName)
    }
    
    func getAllAlbums(userId: Int) {
        self.service.getAlbums(userId: userId) { albums in
            self.viewDelegate?.fillAlbums(albums: albums)
        }
    }
}
