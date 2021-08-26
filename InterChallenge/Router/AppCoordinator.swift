import UIKit
import Foundation

class AppCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
        
    unowned let navigationController:UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewController: ChallengeViewController  = ChallengeViewController()
        let service                                  = UserService()
        let presenter                                = ChallengePresenter(service: service)
        presenter.setCoordinatorDelegate(coordinatorDelegate: self)
        viewController.setupPresenter(presenter: presenter)
        self.navigationController.viewControllers = [viewController]
    }
}

extension AppCoordinator: NextChallengeCoordinatorDelegate {
    func didEnterListAlbum(with userId: Int, by name: String) {
        let coordinator: AlbumsCoordinator = AlbumsCoordinator(navigationController: navigationController)
        coordinator.setDelegate(delegate: self)
        coordinator.setDataAlbum(userId: userId, userName: name)
        
        childCoordinators.append(coordinator)
        coordinator.start()
    }
    
    func didEnterPost(with userId: Int, by name: String) {
        let coordinator: PostCoordinator = PostCoordinator(navigationController: navigationController)
        coordinator.setDelegate(delegate: self)
        coordinator.setDataPost(userId: userId, userName: name)
        
        childCoordinators.append(coordinator)
        coordinator.start()
    }
}

extension AppCoordinator: BackChallengeCoordinatorDelegate {
    func navigateBackToChallengePage(newOrderCoordinator: AppCoordinator) {
        navigationController.popToRootViewController(animated: true)
        childCoordinators.removeLast()
    }
}

