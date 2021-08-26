import Foundation

protocol PhotoViewDelegate: NSObjectProtocol {
    func fillPhotos(photos: [Photo]?)
}

protocol NextPhotoCoordinatorDelegate: class {
    
}

class PhotosPresenter {
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
    
    func getAllPhotos(albumId: Int) {
        self.service.getPhotos(albumId: albumId) { photos in
            self.viewDelegate?.fillPhotos(photos: photos)
        }
    }
}
