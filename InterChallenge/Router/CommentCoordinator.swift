import UIKit
import Foundation

protocol BackPostCoordinatorDelegate: class {
    func navigateBackToPostPage(newOrderCoordinator: PostCoordinator)
}

class CommentCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    unowned let navigationController: UINavigationController
    private var postId: Int?
    private var userName: String?
    
    private weak var delegate: BackPostCoordinatorDelegate?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func setDelegate(delegate: BackPostCoordinatorDelegate) {
        self.delegate = delegate
    }
    
    func setDataComment(postId: Int, userName: String) {
        self.postId     = postId
        self.userName   = userName
    }
    
    func start() {
        showScene()
    }
}

extension CommentCoordinator {
    func showScene() {
        guard let postId = postId,
              let userName = userName else { return }
        
        let viewController                  = CommentTableViewController()
        let service                         = CommentService()
        let presenter                       = CommentPresenter(service: service)
        viewController.setupComment(presenter: presenter, postId: postId, userName: userName)
        
        self.navigationController.pushViewController(viewController, animated: true)
    }
}

