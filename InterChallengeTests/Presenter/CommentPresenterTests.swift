import XCTest
@testable import InterChallenge

class CommentPresenterTests: XCTestCase {
    func test_getAllComments_should_call_fetchUsers_and_pass_the_value_with_comments_to_viewDelegate() {
        let postId = 100
        let comments = [Comment(id: 1, postId: 10, name: "name", body: "body"),
                        Comment(id: 2, postId: 12, name: "name", body: "body"),
                        Comment(id: 3, postId: 13, name: "name", body: "body")]
        let commentViewDelegateMock = CommentViewDelegateMock()
        let remoteCommentServiceSpy = RemoteCommentServiceSpy()
        let sut = CommentPresenter(service: remoteCommentServiceSpy)

        sut.setViewDelegate(viewDelegate: commentViewDelegateMock)
        sut.getAllComments(postId: postId)
        remoteCommentServiceSpy.callbackWithComments(comments)

        XCTAssertEqual(comments, commentViewDelegateMock.comments)
        XCTAssertEqual(postId, remoteCommentServiceSpy.postId)
        XCTAssertNil(commentViewDelegateMock.error)
    }

    func test_getAllComments_should_call_fetchUsers_and_pass_the_value_with_error_to_viewDelegate() {
        let postId = 100
        let commentViewDelegateMock = CommentViewDelegateMock()
        let remoteCommentServiceSpy = RemoteCommentServiceSpy()
        let sut = CommentPresenter(service: remoteCommentServiceSpy)

        sut.setViewDelegate(viewDelegate: commentViewDelegateMock)
        sut.getAllComments(postId: postId)
        remoteCommentServiceSpy.callbackWithError(.unexpected)

        XCTAssertEqual(commentViewDelegateMock.error, .unexpected)
        XCTAssertEqual(postId, remoteCommentServiceSpy.postId)
        XCTAssertNil(commentViewDelegateMock.comments)
    }
}

extension CommentPresenterTests {
    class RemoteCommentServiceSpy: CommentService {
        var postId: Int?
        var callback: ((Result<[Comment], DomainError>) -> Void)?
        
        func fetchComments(postId: Int, callback: @escaping (Result<[Comment], DomainError>) -> Void) {
            self.postId = postId
            self.callback = callback
        }
        
        func callbackWithError(_ error: DomainError) {
            callback?(.failure(error))
        }

        func callbackWithComments(_ comments: [Comment]) {
            callback?(.success(comments))
        }
    }
}

extension CommentPresenterTests {
    class CommentViewDelegateMock: CommentViewDelegate {
        var comments: [Comment]?
        var error: DomainError?
        
        func fillComments(comments: [Comment]) {
            self.comments = comments
        }
        
        func errorPresent(error: DomainError) {
            self.error = error
        }
    }
}

