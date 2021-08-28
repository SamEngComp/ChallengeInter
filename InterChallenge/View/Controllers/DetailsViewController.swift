import UIKit

class DetailsViewController: UIViewController {
    
    var imageUrl: String?
    var name: String?

    lazy var detailImageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 17)
        label.numberOfLines = 3
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Detalhes"
        view.backgroundColor = .white
        navigationController?.navigationBar.isTranslucent = false
        hierarchyView()
        setupConstraints()
    }
    
    private func hierarchyView() {
        view.addSubview(detailImageView)
        view.addSubview(nameLabel)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            detailImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 16),
            detailImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            detailImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            detailImageView.heightAnchor.constraint(equalToConstant: 250),
            
            nameLabel.topAnchor.constraint(equalTo: detailImageView.bottomAnchor, constant: 16),
            nameLabel.leadingAnchor.constraint(equalTo: detailImageView.leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: detailImageView.trailingAnchor)
        ])
    }
    
    func fillNameLabel(name: String) {
        self.nameLabel.text = name
    }
    
    func fillDetailImage(imageUrl: String) {
        AlamofireAdapter.downloadPhoto(url: imageUrl) { data in
            if let data = data {
                self.detailImageView.image = UIImage(data: data) ?? UIImage()
            } else {
                self.errorPresent(error: .unexpected)
            }
        }
    }
    
    private func errorPresent(error: DomainError) {
        let alert = UIAlertController(title: "Erro", message: "Algo errado aconteceu. Tente novamente mais tarde.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { _ in
            alert.dismiss(animated: true)
        }))
        self.present(alert, animated: true)
    }
}
