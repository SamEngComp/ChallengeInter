import Alamofire
import UIKit

class AlbumTableViewController: UITableViewController, AlbumViewDelegate {

    private var userId: Int?
    private var userName: String?
    private var albums = [Album]()
    private var presenter: AlbumsPresenter?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "AlbumTableViewCell", bundle: nil), forCellReuseIdentifier: "AlbumCell")
    }
    
    func setupAlbumTable(presenter: AlbumsPresenter, userId: Int,userName: String) {
        self.userId     = userId
        self.userName   = userName
        self.presenter  = presenter
        startAlbumTable()
    }
    
    func startAlbumTable() {
        guard let userId = userId,
              let userName = userName else { return }
        self.presenter?.setViewDelegate(viewDelegate: self)
        self.presenter?.getAllAlbums(userId: userId)
        navigationItem.title = "Álbuns de \(userName)"
    }
    
    func fillAlbums(albums: [Album]?) {
        guard let albums = albums else {
            errorPresent()
            return
        }
        self.albums = albums
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
        return albums.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AlbumCell", for: indexPath) as? AlbumTableViewCell else {
            return UITableViewCell()
        }

        let album = albums[indexPath.row]
        cell.albumNameLabel.text = album.title

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let albumId = albums[indexPath.row].id
        guard let userName = userName else { return }
        self.presenter?.presetPhoto(albumId: albumId, userName: userName)
    }
    
}
