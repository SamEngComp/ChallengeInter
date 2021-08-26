import UIKit
import Foundation

class AlbumsCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    unowned let navigationController: UINavigationController
    private var userId: Int?
    private var userName: String?
    private weak var delegate: BackChallengeCoordinatorDelegate?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func setDelegate(delegate: BackChallengeCoordinatorDelegate) {
        self.delegate = delegate
    }
    
    func setDataAlbum(userId: Int, userName: String) {
        self.userId = userId
        self.userName = userName
    }
    
    func start() {
        showScene()
    }
}

extension AlbumsCoordinator {
    func showScene() {
        guard let userId = userId,
              let userName = userName else { return }
        let viewController = AlbumTableViewController()
        let service         = AlbumService()
        let presenter       = AlbumsPresenter(service: service)
        presenter.setCoordinatorDelegate(coordinatorDelegate: self)
        viewController.setupAlbumTable(presenter: presenter, userId: userId, userName: userName)
        self.navigationController.pushViewController(viewController, animated: true)
    }
}

extension AlbumsCoordinator: NextAlbumCoordinatorDelegate {
    func didEnterAlbum(with algumId: Int, by name: String) {
        let coordinator: PhotosCoordinator = PhotosCoordinator(navigationController: navigationController)
        coordinator.setDelegate(delegate: self)
        coordinator.setDataPhotos(albumId: algumId, userName: name)
        
        childCoordinators.append(coordinator)
        coordinator.start()
    }
}

extension AlbumsCoordinator: BackChallengeCoordinatorDelegate {
    func navigateBackToChallengePage(newOrderCoordinator: AppCoordinator) {
        navigationController.popToRootViewController(animated: true)
        childCoordinators.removeLast()
    }    
}

extension AlbumsCoordinator: BackAlbumsCoordinatorDelegate {
    func navigateBackToAlbumsPage(newOrderCoordinator: AlbumsCoordinator) {
        navigationController.popToRootViewController(animated: true)
        childCoordinators.removeLast()
    }
}
