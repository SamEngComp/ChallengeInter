import XCTest
@testable import InterChallenge

class PostPresenterTests: XCTestCase {
    func test_getAllPosts_should_call_fetchUsers_and_pass_the_value_with_posts_to_viewDelegate() {
        let userId = 100
        let posts = [Post(id: 1, userId: 12, title: "title-test", body: "body-test"),
                     Post(id: 2, userId: 13, title: "title-test", body: "body-test"),
                     Post(id: 3, userId: 14, title: "title-test", body: "body-test")]
        let postViewDelegateMock = PostViewDelegateMock()
        let remotePostServiceSpy = RemotePostServiceSpy()
        let sut = PostPresenter(service: remotePostServiceSpy)
        
        sut.setViewDelegate(viewDelegate: postViewDelegateMock)
        sut.getAllPosts(userId: userId)
        remotePostServiceSpy.callbackWithPosts(posts)
        
        XCTAssertEqual(posts, postViewDelegateMock.posts)
        XCTAssertEqual(userId, remotePostServiceSpy.userId)
        XCTAssertNil(postViewDelegateMock.error)
    }
    
    func test_getAllPosts_should_call_fetchUsers_and_pass_the_value_with_error_to_viewDelegate() {
        let userId = 100
        let postViewDelegateMock = PostViewDelegateMock()
        let remotePostServiceSpy = RemotePostServiceSpy()
        let sut = PostPresenter(service: remotePostServiceSpy)
        
        sut.setViewDelegate(viewDelegate: postViewDelegateMock)
        sut.getAllPosts(userId: userId)
        remotePostServiceSpy.callbackWithError(.unexpected)
        
        XCTAssertEqual(postViewDelegateMock.error, .unexpected)
        XCTAssertEqual(userId, remotePostServiceSpy.userId)
        XCTAssertNil(postViewDelegateMock.posts)
    }

    func test_presentAlbum_should_call_didEnterComment_of_coordinator() {
        let postId = 100
        let name = "name-test"
        let nextPostCoordinatorSpy = NextPostCoordinatorSpy()
        let remotePostServiceSpy = RemotePostServiceSpy()
        let sut = PostPresenter(service: remotePostServiceSpy)
        
        sut.setCoordinatorDelegate(coordinatorDelegate: nextPostCoordinatorSpy)
        sut.presentComment(postId: postId, name: name)
        
        XCTAssertEqual(postId, nextPostCoordinatorSpy.postId)
        XCTAssertEqual(name, nextPostCoordinatorSpy.name)
    }
}

extension PostPresenterTests {
    class RemotePostServiceSpy: PostService {
        var userId: Int?
        var callback: ((Result<[Post], DomainError>) -> Void)?
        
        func fetchPosts(userId: Int, callback: @escaping (Result<[Post], DomainError>) -> Void) {
            self.userId = userId
            self.callback = callback
        }
        
        func callbackWithError(_ error: DomainError) {
            callback?(.failure(error))
        }

        func callbackWithPosts(_ posts: [Post]) {
            callback?(.success(posts))
        }
    }
}

extension PostPresenterTests {
    class PostViewDelegateMock: PostViewDelegate {
        var posts: [Post]?
        var error: DomainError?
        
        func fillPosts(posts: [Post]) {
            self.posts = posts
        }
        
        func errorPresent(error: DomainError) {
            self.error = error
        }
    }
}

extension PostPresenterTests {
    class NextPostCoordinatorSpy: NextPostCoordinatorDelegate {
        var postId: Int?
        var name: String?
        
        func didEnterComment(with postId: Int, by name: String) {
            self.postId = postId
            self.name = name
        }
    }
}
