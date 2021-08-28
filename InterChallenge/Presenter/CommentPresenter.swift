import Foundation

protocol CommentViewDelegate: class {
    func fillComments(comments: [Comment])
    func errorPresent(error: DomainError)
}

class CommentPresenter {
    private weak var viewDelegate: CommentViewDelegate?
    private let service: CommentService
    
    init(service: CommentService) {
        self.service = service
    }
    
    func setViewDelegate(viewDelegate: CommentViewDelegate) {
        self.viewDelegate = viewDelegate
    }
    
    func getAllComments(postId: Int) {
        service.fetchComments(postId: postId) { result in
            switch result {
            case .success(let comments):
                self.viewDelegate?.fillComments(comments: comments)
            case .failure(let error):
                self.viewDelegate?.errorPresent(error: error)
            }
            
        }
    }
}
