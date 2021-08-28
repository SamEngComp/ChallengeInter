import UIKit

class PhotoTableViewController: UITableViewController, PhotoViewDelegate {

    private var albumId: Int?
    private var name: String?
    private var photos = [Photo]()
    private var presenter: PhotoPresenter?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(PhotoTableViewCell.self, forCellReuseIdentifier: PhotoTableViewCell.identifierCell)
    }
    
    func setupPhotoTable(presenter: PhotoPresenter, albumId: Int, name: String) {
        self.presenter  = presenter
        self.albumId    = albumId
        self.name   = name
        startPhotoTable()
    }
    
    private func startPhotoTable() {
        guard let albumId = albumId,
              let name = name else {
            return
        }
        presenter?.setViewDelegate(viewDelegate: self)
        presenter?.getAllPhotos(albumId: albumId)
        navigationItem.title = "Fotos de \(name)"
    }
    
    func fillPhotos(photos: [Photo]) {
        self.photos = photos
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func errorPresent(error: DomainError) {
        let alert = UIAlertController(title: "Erro", message: "Algo errado aconteceu. Tente novamente mais tarde.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { _ in
            alert.dismiss(animated: true)
        }))
        self.present(alert, animated: true)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PhotoTableViewCell.identifierCell, for: indexPath) as? PhotoTableViewCell else {
            return UITableViewCell()
        }

        let photo = photos[indexPath.row]
        cell.titleLabel.text = photo.title
        AlamofireAdapter.downloadPhoto(url: photo.thumbnailUrl) { data in
            if let data = data {
                cell.photoImageView.image = UIImage(data: data)
            }
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let photo = photos[indexPath.row]
        presenter?.presentPhoto(imageUrl: photo.thumbnailUrl, name: photo.title)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170
    }
}
