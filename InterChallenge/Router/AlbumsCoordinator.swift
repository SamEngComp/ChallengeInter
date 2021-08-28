import UIKit
import Foundation

class AlbumsCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    unowned let navigationController: UINavigationController
    
    private var userId: Int?
    private var name: String?
    private weak var delegate: BackCoordinatorDelegate?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func setDelegate(delegate: BackCoordinatorDelegate) {
        self.delegate = delegate
    }
    
    func setDataAlbum(userId: Int, name: String) {
        self.userId = userId
        self.name = name
    }
    
    func start() {
        showScene()
    }
}

extension AlbumsCoordinator {
    func showScene() {
        guard let userId = userId,
              let name = name else { return }
        let url = URL(string: "https://jsonplaceholder.typicode.com/albums?userId=")!
        
        let viewController = AlbumTableViewController()
        let service        = RemoteFetchAlbums(url: url, httpGetClient: AlamofireAdapter())
        let presenter      = AlbumPresenter(service: service)
        
        presenter.setCoordinatorDelegate(coordinatorDelegate: self)
        viewController.setupAlbumTable(presenter: presenter, userId: userId, name: name)
        
        self.navigationController.pushViewController(viewController, animated: true)
    }
}

extension AlbumsCoordinator: NextAlbumCoordinatorDelegate {
    func didEnterAlbum(with algumId: Int, by name: String) {
        let coordinator: PhotosCoordinator = PhotosCoordinator(navigationController: navigationController)
        coordinator.setDelegate(delegate: self)
        coordinator.setDataPhotos(albumId: algumId, name: name)
        
        childCoordinators.append(coordinator)
        coordinator.start()
    }
}

extension AlbumsCoordinator: BackCoordinatorDelegate {
    func navigateBackPage(newOrderCoordinator: Coordinator) {
        navigationController.popToRootViewController(animated: true)
        childCoordinators.removeLast()
    }
}
