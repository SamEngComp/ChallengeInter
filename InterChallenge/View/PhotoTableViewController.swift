import Alamofire
import UIKit

class PhotoTableViewController: UITableViewController, PhotoViewDelegate {

    private var albumId: Int?
    private var userName: String?
    private var photos = [Photo]()
    private var presenter: PhotosPresenter?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "PhotoTableViewCell", bundle: nil), forCellReuseIdentifier: "PhotoCell")
        //fillPhotos(from: albumId)
    }
    
    func setupPhotoTable(presenter: PhotosPresenter, albumId: Int, userName: String) {
        self.presenter  = presenter
        self.albumId    = albumId
        self.userName   = userName
        startPhotoTable()
    }
    
    private func startPhotoTable() {
        guard let albumId = albumId,
              let userName = userName else {
            errorPresent()
            return
        }
        presenter?.setViewDelegate(viewDelegate: self)
        presenter?.getAllPhotos(albumId: albumId)
        navigationItem.title = "Fotos de \(userName)"
    }
    
    func fillPhotos(photos: [Photo]?) {
        guard let photos = photos else {
            errorPresent()
            return
        }
        self.photos = photos
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    private func errorPresent() {
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PhotoCell", for: indexPath) as? PhotoTableViewCell else {
            return UITableViewCell()
        }

        let photo = photos[indexPath.row]
        cell.titleLabel.text = photo.title
        
        AF.download(photo.thumbnailUrl).responseData { response in
            switch response.result {
            case .success(let data):
                cell.photoImageView.image = UIImage(data: data)
            default:
                break
            }
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let photo = photos[indexPath.row]
        AF.download(photo.url).responseData { response in
            switch response.result {
            case .success(let data):
                self.performSegue(withIdentifier: "photoToDetail",
                                  sender: (photo: UIImage(data: data), name: photo.title))
            default:
                break
            }
        }
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinatinVC = segue.destination as? DetailsViewController {
            if let info = sender as? (photo: UIImage, name: String) {
                destinatinVC.photo = info.photo
                destinatinVC.name = info.name
            }
        }
    }
}
