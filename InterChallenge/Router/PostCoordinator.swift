import UIKit
import Foundation

class PostCoordinator: Coordinator {
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
    
    func setDataPost(userId: Int, name: String) {
        self.userId     = userId
        self.name   = name
    }
    
    func start() {
        showScene()
    }
}

extension PostCoordinator {
    func showScene() {
        guard let userId = userId,
              let name = name else { return }
        let viewController = PostTableViewController()
        let service        = RemotePostService()
        let presenter      = PostPresenter(service: service)
        
        presenter.setCoordinatorDelegate(coordinatorDelegate: self)
        viewController.setupPostTable(presenter: presenter, userId: userId, name: name)
    
        self.navigationController.pushViewController(viewController, animated: true)
    }
}

extension PostCoordinator: NextPostCoordinatorDelegate {
    func didEnterComment(with postId: Int, by name: String) {
        let coordinator: CommentCoordinator = CommentCoordinator(navigationController: navigationController)
        coordinator.setDelegate(delegate: self)
        coordinator.setDataComment(postId: postId, name: name)
        
        childCoordinators.append(coordinator)
        coordinator.start()
    }
}

extension PostCoordinator: BackCoordinatorDelegate {
    func navigateBackPage(newOrderCoordinator: Coordinator) {
        navigationController.popToRootViewController(animated: true)
        childCoordinators.removeLast()
    }
}
