import UIKit
import Foundation

class CommentCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    unowned let navigationController: UINavigationController
    
    private var postId: Int?
    private var name: String?
    private weak var delegate: BackCoordinatorDelegate?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func setDelegate(delegate: BackCoordinatorDelegate) {
        self.delegate = delegate
    }
    
    func setDataComment(postId: Int, name: String) {
        self.postId     = postId
        self.name   = name
    }
    
    func start() {
        showScene()
    }
}

extension CommentCoordinator {
    func showScene() {
        guard let postId = postId,
              let name = name else { return }
        let viewController = CommentTableViewController()
        let service        = RemoteCommentService()
        let presenter      = CommentPresenter(service: service)
        viewController.setupComment(presenter: presenter, postId: postId, name: name)
        
        self.navigationController.pushViewController(viewController, animated: true)
    }
}

