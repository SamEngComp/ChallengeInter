import XCTest
@testable import InterChallenge

class PostPresenterTests: XCTestCase {
    func test_getAllPosts_should_call_getUser_and_pass_to_viewDelegate() {
        let userId = 100
        let posts = [Post(id: 1, userId: 12, title: "title-test", body: "body-test"),
                     Post(id: 2, userId: 13, title: "title-test", body: "body-test"),
                     Post(id: 3, userId: 14, title: "title-test", body: "body-test")]
        let postViewDelegateMock = PostViewDelegateMock()
        let remoteFetchPostsSpy = RemoteFetchPostsSpy()
        let sut = PostPresenter(service: remoteFetchPostsSpy)
        
        sut.setViewDelegate(viewDelegate: postViewDelegateMock)
        sut.getAllPosts(userId: userId)
        remoteFetchPostsSpy.callbackWithPosts(posts)
        
        XCTAssertEqual(posts, postViewDelegateMock.posts)
        XCTAssertEqual(userId, remoteFetchPostsSpy.userId)
        XCTAssertNil(postViewDelegateMock.error)
    }
    
    func test_getAllPosts_should_call_getUser_and_pass_to_viewDelegate2() {
        let userId = 100
        let postViewDelegateMock = PostViewDelegateMock()
        let remoteFetchPostsSpy = RemoteFetchPostsSpy()
        let sut = PostPresenter(service: remoteFetchPostsSpy)
        
        sut.setViewDelegate(viewDelegate: postViewDelegateMock)
        sut.getAllPosts(userId: userId)
        remoteFetchPostsSpy.callbackWithError(.unexpected)
        
        XCTAssertEqual(postViewDelegateMock.error, .unexpected)
        XCTAssertEqual(userId, remoteFetchPostsSpy.userId)
        XCTAssertNil(postViewDelegateMock.posts)
    }

    func test_presentAlbum_should_call_didEnterListAlbum_of_coordinator() {
        let postId = 100
        let name = "name-test"
        let nextPostCoordinatorSpy = NextPostCoordinatorSpy()
        let remoteFetchPostsSpy = RemoteFetchPostsSpy()
        let sut = PostPresenter(service: remoteFetchPostsSpy)
        
        sut.setCoordinatorDelegate(coordinatorDelegate: nextPostCoordinatorSpy)
        sut.presentComment(postId: postId, name: name)
        
        XCTAssertEqual(postId, nextPostCoordinatorSpy.postId)
        XCTAssertEqual(name, nextPostCoordinatorSpy.name)
    }
}

extension PostPresenterTests {
    class RemoteFetchPostsSpy: FetchPosts {
        var userId: Int?
        var callback: ((Result<[Post], DomainError>) -> Void)?
        
        func fetch(userId: Int, callback: @escaping (Result<[Post], DomainError>) -> Void) {
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
