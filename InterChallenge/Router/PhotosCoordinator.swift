import UIKit
import Foundation

protocol BackAlbumsCoordinatorDelegate: class {
    func navigateBackToAlbumsPage(newOrderCoordinator: AlbumsCoordinator)
}

class PhotosCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    unowned let navigationController: UINavigationController
    private var albumId: Int?
    private var userName: String?
    private var delegate: BackAlbumsCoordinatorDelegate?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func setDataPhotos(albumId: Int, userName: String) {
        self.albumId    = albumId
        self.userName   = userName
    }
    
    func setDelegate(delegate: BackAlbumsCoordinatorDelegate) {
        self.delegate = delegate
    }
    
    func start() {
        showScene()
    }
}

extension PhotosCoordinator {
    func showScene() {
        guard let albumId   = albumId,
              let userName  = userName else { return }
        let viewController  = PhotoTableViewController()
        let service         = PhotoService()
        let presenter       = PhotosPresenter(service: service)
        viewController.setupPhotoTable(presenter: presenter, albumId: albumId, userName: userName)
        self.navigationController.pushViewController(viewController, animated: true)
    }
}

extension PhotosCoordinator: NextPhotoCoordinatorDelegate {
    
}
