import Alamofire
import UIKit

class AlbumTableViewController: UITableViewController, AlbumViewDelegate {

    private var userId: Int?
    private var name: String?
    private var albums = [Album]()
    private var presenter: AlbumPresenter?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(AlbumTableViewCell.self, forCellReuseIdentifier: AlbumTableViewCell.identifierCell)
    }
    
    func setupAlbumTable(presenter: AlbumPresenter, userId: Int, name: String) {
        self.userId = userId
        self.name   = name
        self.presenter  = presenter
        startAlbumTable()
    }
    
    func startAlbumTable() {
        guard let userId = userId,
              let name = name else { return }
        self.presenter?.setViewDelegate(viewDelegate: self)
        self.presenter?.getAllAlbums(userId: userId)
        navigationItem.title = "Álbuns de \(name)"
    }
    
    func fillAlbums(albums: [Album]) {
        self.albums = albums
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func errorPresent(error: DomainError) {
        let alert = UIAlertController(title: "Error - \(error.localizedDescription)", message: "Algo errado aconteceu. Tente novamente mais tarde.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { _ in
            alert.dismiss(animated: true)
        }))
        self.present(alert, animated: true)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albums.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AlbumTableViewCell.identifierCell, for: indexPath) as? AlbumTableViewCell else {
            return UITableViewCell()
        }

        let album = albums[indexPath.row]
        cell.albumNameLabel.text = album.title

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let albumId = albums[indexPath.row].id
        guard let name = name else { return }
        self.presenter?.presetPhoto(albumId: albumId, name:  name)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
}
