import Foundation

protocol PostViewDelegate: NSObjectProtocol {
    func fillPosts(posts: [Post]?)
}

protocol NextPostCoordinatorDelegate: class {
    func didEnterComment(with postId: Int, by name: String)
}

class PostPresenter {
    private weak var coordinatorDelegate: NextPostCoordinatorDelegate?
    private weak var viewDelegate: PostViewDelegate?
    private let service: PostService
    
    init(service: PostService) {
        self.service = service
    }
    
    func setViewDelegate(viewDelegate: PostViewDelegate) {
        self.viewDelegate = viewDelegate
    }
    
    func setCoordinatorDelegate(coordinatorDelegate: NextPostCoordinatorDelegate) {
        self.coordinatorDelegate = coordinatorDelegate
    }
    
    func presentPostDetails(userId: Int, name: String) {
        self.coordinatorDelegate?.didEnterComment(with: userId, by: name)
    }
    
    func presentComment(postId: Int, name: String) {
        self.coordinatorDelegate?.didEnterComment(with: postId, by: name)
    }
    
    func getAllPosts(userId: Int) {
        service.getPosts(userId: userId) { posts in
            self.viewDelegate?.fillPosts(posts: posts)
        }
    }
}
