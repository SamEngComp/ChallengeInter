import Foundation
import UIKit

class DetailsCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    unowned var navigationController: UINavigationController
    
    private var imageUrl: String?
    private var name: String?
    private var delegate: BackCoordinatorDelegate?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func setDataDetails(imageUrl: String, name: String) {
        self.imageUrl = imageUrl
        self.name = name
    }
    
    func setDelegate(delegate: BackCoordinatorDelegate) {
        self.delegate = delegate
    }
    
    func start() {
        guard let name = name,
              let imageUrl = imageUrl else { return }
        let viewController = DetailsViewController()
        viewController.fillNameLabel(name: name)
        viewController.fillDetailImage(imageUrl: imageUrl)
        self.navigationController.pushViewController(viewController, animated: true)        
    }
}
