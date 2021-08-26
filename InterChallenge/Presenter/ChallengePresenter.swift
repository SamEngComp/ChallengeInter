import Foundation

protocol ChallengeViewDelegate: NSObjectProtocol {
    func fillUsers(users: [User]?)
}

protocol NextChallengeCoordinatorDelegate: class {
    func didEnterListAlbum(with userId: Int, by name: String)
    func didEnterPost(with userId: Int, by name: String)
}

class ChallengePresenter {
    private weak var coordinatorDelegate: NextChallengeCoordinatorDelegate?
    private weak var viewDelegate: ChallengeViewDelegate?
    private let service: UserService
    
    init(service: UserService) {
        self.service = service
    }
    
    func setViewDelegate(viewDelegate: ChallengeViewDelegate) {
        self.viewDelegate = viewDelegate
    }
    
    func setCoordinatorDelegate(coordinatorDelegate: NextChallengeCoordinatorDelegate) {
        self.coordinatorDelegate = coordinatorDelegate
    }
    
    func presentAlbum(userId: Int, name: String) {
        self.coordinatorDelegate?.didEnterListAlbum(with: userId, by: name)
    }
    
    func presentPost(userId: Int, name: String) {
        self.coordinatorDelegate?.didEnterPost(with: userId, by: name)
    }
    
    func getAllUsers() {
        service.getUsers() { users in
            self.viewDelegate?.fillUsers(users: users)
        }
    }
}
