import Alamofire
import UIKit

class UserTableViewController: UITableViewController, UserViewDelegate {
    
    private var users = [User]()
    private var presenter: UserPresenter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title  = "Desafio"
        
        tableView.register(UserTableViewCell.self, forCellReuseIdentifier: UserTableViewCell.identifierCell)
    }
    
    func setupPresenter(presenter: UserPresenter) {
        self.presenter = presenter
        self.presenter?.setViewDelegate(viewDelegate: self)
        self.presenter?.getAllUsers()
    }
    
    func fillUsers(users: [User]) {
        self.users = users
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
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UserTableViewCell.identifierCell, for: indexPath) as? UserTableViewCell else {
            return UITableViewCell()
        }
        let user = users[indexPath.row]
        cell.selectionStyle = .none
        cell.id = user.id
        cell.initialsLabel.text = String(user.name.prefix(2))
        cell.nameLabel.text = user.name
        cell.userNameLabel.text = user.username
        cell.emailLabel.text = user.email
        cell.phoneLabel.text = user.phone
        cell.delegate = self
        cell.contentView.backgroundColor = indexPath.row % 2 == 0 ? .white : UIColor(white: 0.667, alpha: 0.2)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 240
    }
}

extension UserTableViewController: UserTableViewCellDelegate {
    func didTapAlbums(with userId: Int, by name: String) {
        presenter?.presentAlbum(userId: userId, name: name)
    }
    
    func didTapPosts(with userId: Int, by name: String) {
        presenter?.presentPost(userId: userId, name: name)
    }
}
