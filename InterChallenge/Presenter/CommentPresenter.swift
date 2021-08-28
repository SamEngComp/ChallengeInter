import Foundation

protocol CommentViewDelegate: class {
    func fillComments(comments: [Comment])
    func errorPresent(error: DomainError)
}

class CommentPresenter {
    private weak var viewDelegate: CommentViewDelegate?
    private let service: FetchComments
    
    init(service: FetchComments) {
        self.service = service
    }
    
    func setViewDelegate(viewDelegate: CommentViewDelegate) {
        self.viewDelegate = viewDelegate
    }
    
    func getAllComments(postId: Int) {
        service.fetch(postId: postId) { result in
            switch result {
            case .success(let comments):
                self.viewDelegate?.fillComments(comments: comments)
            case .failure(let error):
                self.viewDelegate?.errorPresent(error: error)
            }
            
        }
    }
}
