import Foundation

protocol UserViewDelegate: class {
    func fillUsers(users: [User])
    func errorPresent(error: DomainError)
}

protocol NextUserCoordinatorDelegate: class {
    func didEnterListAlbum(with userId: Int, by name: String)
    func didEnterPost(with userId: Int, by name: String)
}

class UserPresenter {
    private weak var coordinatorDelegate: NextUserCoordinatorDelegate?
    private weak var viewDelegate: UserViewDelegate?
    private let service: FetchUsers
    
    init(service: FetchUsers) {
        self.service = service
    }
    
    func setViewDelegate(viewDelegate: UserViewDelegate) {
        self.viewDelegate = viewDelegate
    }
    
    func setCoordinatorDelegate(coordinatorDelegate: NextUserCoordinatorDelegate) {
        self.coordinatorDelegate = coordinatorDelegate
    }
    
    func presentAlbum(userId: Int, name: String) {
        self.coordinatorDelegate?.didEnterListAlbum(with: userId, by: name)
    }
    
    func presentPost(userId: Int, name: String) {
        self.coordinatorDelegate?.didEnterPost(with: userId, by: name)
    }
    
    func getAllUsers() {
        service.fetch() { result in
            switch result {
            case .success(let users):
                self.viewDelegate?.fillUsers(users: users)
            case .failure(let error):
                self.viewDelegate?.errorPresent(error: error)
            }
            
        }
    }
}
