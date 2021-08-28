import Foundation

protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }
    func start()
}

protocol BackCoordinatorDelegate: class {
    func navigateBackPage(newOrderCoordinator: Coordinator)
}
