import Alamofire
import UIKit

class PostTableViewController: UITableViewController, PostViewDelegate {

    private var userId: Int?
    private var name: String?
    private var posts = [Post]()
    private var presenter: PostPresenter?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(TitleAndDescriptionTableViewCell.self, forCellReuseIdentifier: TitleAndDescriptionTableViewCell.identifierCell)
    }
    
    func setupPostTable(presenter: PostPresenter, userId: Int, name: String) {
        self.presenter  = presenter
        self.userId     = userId
        self.name   = name
        startPostTable()
    }
    
    private func startPostTable() {
        guard let userId = userId,
              let name = name else { return }
        self.presenter?.setViewDelegate(viewDelegate: self)
        self.presenter?.getAllPosts(userId: userId)
        navigationItem.title = "Álbuns de \(name)"
    }
    
    func fillPosts(posts: [Post]) {
        self.posts = posts
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
        return posts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleAndDescriptionTableViewCell.identifierCell, for: indexPath) as? TitleAndDescriptionTableViewCell else {
            return UITableViewCell()
        }

        let post = posts[indexPath.row]
        cell.titleLabel.text = post.title
        cell.descriptionLabel.text = post.body

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let postId = posts[indexPath.row].id
        guard let name = name else { return }
        self.presenter?.presentComment(postId: postId, name: name)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 230
    }
}
