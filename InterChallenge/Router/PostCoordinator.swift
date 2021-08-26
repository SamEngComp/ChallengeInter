import UIKit
import Foundation

protocol BackChallengeCoordinatorDelegate: class {
    func navigateBackToChallengePage(newOrderCoordinator: AppCoordinator)
}

class PostCoordinator: Coordinator {
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
    
    func setDataPost(userId: Int, userName: String) {
        self.userId     = userId
        self.userName   = userName
    }
    
    func start() {
        showScene()
    }
}

extension PostCoordinator {
    func showScene() {
        guard let userId = userId,
              let userName = userName else { return }
        
        let viewController                  = PostTableViewController()
        let service                         = PostService()
        let presenter                       = PostPresenter(service: service)
        presenter.setCoordinatorDelegate(coordinatorDelegate: self)
        viewController.setupPostTable(presenter: presenter, userId: userId, userName: userName)
        
        self.navigationController.pushViewController(viewController, animated: true)
    }
}

extension PostCoordinator: NextPostCoordinatorDelegate {
    func didEnterComment(with postId: Int, by name: String) {
        let coordinator: CommentCoordinator = CommentCoordinator(navigationController: navigationController)
        coordinator.setDelegate(delegate: self)
        coordinator.setDataComment(postId: postId, userName: name)
        
        childCoordinators.append(coordinator)
        coordinator.start()
    }
}

extension PostCoordinator: BackPostCoordinatorDelegate {
    func navigateBackToPostPage(newOrderCoordinator: PostCoordinator) {
        navigationController.popToRootViewController(animated: true)
        childCoordinators.removeLast()
    }
}
