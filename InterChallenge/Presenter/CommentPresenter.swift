import Foundation

protocol CommentViewDelegate: NSObjectProtocol {
    func fillComments(comments: [Comment]?)
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
        self.service.getComments(postId: postId) { comments in
            self.viewDelegate?.fillComments(comments: comments)
        }
    }
}
