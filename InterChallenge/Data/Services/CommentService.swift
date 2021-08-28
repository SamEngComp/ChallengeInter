import Foundation

protocol CommentService {
    func fetchComments(postId: Int, callback: @escaping (Result<[Comment], DomainError>)->Void)
}
