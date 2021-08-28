import UIKit
import Foundation

class PhotosCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    unowned let navigationController: UINavigationController
    
    private var albumId: Int?
    private var name: String?
    private var delegate: BackCoordinatorDelegate?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func setDataPhotos(albumId: Int, name: String) {
        self.albumId    = albumId
        self.name   = name
    }
    
    func setDelegate(delegate: BackCoordinatorDelegate) {
        self.delegate = delegate
    }
    
    func start() {
        showScene()
    }
}

extension PhotosCoordinator {
    func showScene() {
        guard let albumId   = albumId,
              let name  = name else { return }
        let url = URL(string: "https://jsonplaceholder.typicode.com/photos?albumId=")!
        
        let viewController  = PhotoTableViewController()
        let service         = RemoteFetchPhotos(url: url, httpGetClient: AlamofireAdapter())
        let presenter       = PhotoPresenter(service: service)
        
        presenter.setCoordinatorDelegate(coordinatorDelegate: self)
        viewController.setupPhotoTable(presenter: presenter, albumId: albumId, name: name)
        
        self.navigationController.pushViewController(viewController, animated: true)
    }
}

extension PhotosCoordinator: NextPhotoCoordinatorDelegate {
    func didEnterPhoto(with imageUrl: String, by name: String) {
        let coordinator: DetailsCoordinator = DetailsCoordinator(navigationController: navigationController)
        coordinator.setDelegate(delegate: self)
        coordinator.setDataDetails(imageUrl: imageUrl, name: name)
        
        childCoordinators.append(coordinator)
        coordinator.start()
    }
}

extension PhotosCoordinator: BackCoordinatorDelegate {
    func navigateBackPage(newOrderCoordinator: Coordinator) {
        navigationController.popToRootViewController(animated: true)
        childCoordinators.removeLast()
    }
}
