import Foundation

protocol PostViewDelegate: class {
    func fillPosts(posts: [Post])
    func errorPresent(error: DomainError)
}

protocol NextPostCoordinatorDelegate: class {
    func didEnterComment(with postId: Int, by name: String)
}

class PostPresenter {
    private weak var coordinatorDelegate: NextPostCoordinatorDelegate?
    private weak var viewDelegate: PostViewDelegate?
    private let service: FetchPosts
    
    init(service: FetchPosts) {
        self.service = service
    }
    
    func setViewDelegate(viewDelegate: PostViewDelegate) {
        self.viewDelegate = viewDelegate
    }
    
    func setCoordinatorDelegate(coordinatorDelegate: NextPostCoordinatorDelegate) {
        self.coordinatorDelegate = coordinatorDelegate
    }
    
    func presentComment(postId: Int, name: String) {
        self.coordinatorDelegate?.didEnterComment(with: postId, by: name)
    }
    
    func getAllPosts(userId: Int) {
        service.fetch(userId: userId) { result in
            switch result {
            case .success(let posts):
                self.viewDelegate?.fillPosts(posts: posts)
            case .failure(let error):
                self.viewDelegate?.errorPresent(error: error)
            }
            
        }
    }
}
