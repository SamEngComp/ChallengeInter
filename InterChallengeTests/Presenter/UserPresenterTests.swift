import XCTest
@testable import InterChallenge

class UserPresenterTests: XCTestCase {
    func test_getAllUsers_should_call_fetchUsers_and_pass_the_value_with_users_to_viewDelegate() {
        let users = [User(id: 1, name: "name", username: "username", email: "email@fake.com", phone: "(88) 87665 8876"),
                     User(id: 2, name: "name", username: "username", email: "email@fake.com", phone: "(88) 87665 8876"),
                     User(id: 3, name: "name", username: "username", email: "email@fake.com", phone: "(88) 87665 8876")]
        
        let userViewDelegateMock = UserViewDelegateMock()
        let remoteUserServiceSpy  = RemoteUserServiceSpy()
        let sut = UserPresenter(service: remoteUserServiceSpy)
        
        sut.setViewDelegate(viewDelegate: userViewDelegateMock)
        sut.getAllUsers()
        remoteUserServiceSpy.callbackWithUsers(users)
        
        XCTAssertNil(userViewDelegateMock.error)
        XCTAssertEqual(users, userViewDelegateMock.users)
    }
    
    func test_getAllUsers_should_call_fetchUsers_and_pass_the_value_with_error_to_viewDelegate() {
        let userViewDelegateMock = UserViewDelegateMock()
        let remoteUserServiceSpy = RemoteUserServiceSpy()
        let sut = UserPresenter(service: remoteUserServiceSpy)
        
        sut.setViewDelegate(viewDelegate: userViewDelegateMock)
        sut.getAllUsers()
        remoteUserServiceSpy.callbackWithError(.unexpected)
        
        XCTAssertNil(userViewDelegateMock.users)
        XCTAssertEqual(.unexpected, userViewDelegateMock.error)
    }
    
    func test_presentAlbum_should_call_didEnterListAlbum_of_coordinator() {
        let userId = 100
        let name = "name-test"
        let nextUserCoordinatorSpy = NextUserCoordinatorSpy()
        let remoteUserServiceSpy = RemoteUserServiceSpy()
        let sut = UserPresenter(service: remoteUserServiceSpy)
        
        sut.setCoordinatorDelegate(coordinatorDelegate: nextUserCoordinatorSpy)
        sut.presentAlbum(userId: userId, name: name)
        
        XCTAssertEqual(userId, nextUserCoordinatorSpy.userId)
        XCTAssertEqual(name, nextUserCoordinatorSpy.name)
    }

    func test_presentPost_should_call_didEnterPost_of_coordinator() {
        let userId = 100
        let name = "name-test"
        let nextUserCoordinatorSpy = NextUserCoordinatorSpy()
        let remoteUserServiceSpy = RemoteUserServiceSpy()
        let sut = UserPresenter(service: remoteUserServiceSpy)
        
        sut.setCoordinatorDelegate(coordinatorDelegate: nextUserCoordinatorSpy)
        sut.presentPost(userId: userId, name: name)
        
        XCTAssertEqual(userId, nextUserCoordinatorSpy.userId)
        XCTAssertEqual(name, nextUserCoordinatorSpy.name)
    }
}

extension UserPresenterTests {
    class  RemoteUserServiceSpy: UserService {
        var callback: ((Result<[User], DomainError>) -> Void)?
 
        func fetchUsers(callback: @escaping (Result<[User], DomainError>) -> Void) {
            self.callback = callback
        }
        
        func callbackWithError(_ error: DomainError) {
            callback?(.failure(error))
        }

        func callbackWithUsers(_ users: [User]) {
            callback?(.success(users))
        }
    }
}

extension UserPresenterTests {
    class UserViewDelegateMock: UserViewDelegate {
        var users: [User]?
        var error: DomainError?
        func fillUsers(users: [User]) {
            self.users = users
        }
        
        func errorPresent(error: DomainError) {
            self.error = error
        }
    }
}

extension UserPresenterTests {
    class NextUserCoordinatorSpy: NextUserCoordinatorDelegate {
        var userId: Int?
        var name: String?
        
        func didEnterListAlbum(with userId: Int, by name: String) {
            self.userId = userId
            self.name = name
        }
        
        func didEnterPost(with userId: Int, by name: String) {
            self.userId = userId
            self.name = name
        }
    }
}
