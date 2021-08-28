import Foundation

protocol PhotoViewDelegate: class {
    func fillPhotos(photos: [Photo])
    func errorPresent(error: DomainError)
}

protocol NextPhotoCoordinatorDelegate: class {
    func didEnterPhoto(with imageUrl: String, by name: String)
}

class PhotoPresenter {
    private weak var viewDelegate: PhotoViewDelegate?
    private weak var coordinatorDelegate: NextPhotoCoordinatorDelegate?
    private let service: PhotoService
    
    init(service: PhotoService) {
        self.service = service
    }
    
    func setViewDelegate(viewDelegate: PhotoViewDelegate) {
        self.viewDelegate = viewDelegate
    }
    
    func setCoordinatorDelegate(coordinatorDelegate: NextPhotoCoordinatorDelegate) {
        self.coordinatorDelegate = coordinatorDelegate
    }
    
    func presentPhoto(imageUrl: String, name: String) {
        coordinatorDelegate?.didEnterPhoto(with: imageUrl, by: name)
    }
    
    func getAllPhotos(albumId: Int) {
        service.fetchPhotos(albumId: albumId) { result in
            switch result {
            case .success(let photos):
                self.viewDelegate?.fillPhotos(photos: photos)
            case .failure(let error):
                self.viewDelegate?.errorPresent(error: error)
            }
        }
    }
}
