import UIKit
import Foundation

class AppCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    unowned let navigationController:UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        showScene()
    }
}

extension AppCoordinator {
    func showScene() {
        let viewController = UserTableViewController()
        let service   = RemoteUserService()
        let presenter = UserPresenter(service: service)
        
        presenter.setCoordinatorDelegate(coordinatorDelegate: self)
        viewController.setupPresenter(presenter: presenter)
        
        self.navigationController.viewControllers = [viewController]
    }
}

extension AppCoordinator: NextUserCoordinatorDelegate {
    func didEnterListAlbum(with userId: Int, by name: String) {
        let coordinator: AlbumsCoordinator = AlbumsCoordinator(navigationController: navigationController)
        coordinator.setDelegate(delegate: self)
        coordinator.setDataAlbum(userId: userId, name: name)
        
        childCoordinators.append(coordinator)
        coordinator.start()
    }
    
    func didEnterPost(with userId: Int, by name: String) {
        let coordinator: PostCoordinator = PostCoordinator(navigationController: navigationController)
        coordinator.setDelegate(delegate: self)
        coordinator.setDataPost(userId: userId, name: name)
        
        childCoordinators.append(coordinator)
        coordinator.start()
    }
}

extension AppCoordinator: BackCoordinatorDelegate {
    func navigateBackPage(newOrderCoordinator: Coordinator) {
        navigationController.popToRootViewController(animated: true)
        childCoordinators.removeLast()
    }
}

