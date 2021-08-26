import Alamofire
import UIKit

class PostTableViewController: UITableViewController, PostViewDelegate {

    private var userId: Int?
    private var userName: String?
    private var posts = [Post]()
    private var presenter: PostPresenter?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "TitleAndDescriptionTableViewCell", bundle: nil),
                           forCellReuseIdentifier: "TitleAndDescriptionCell")
    }
    
    func setupPostTable(presenter: PostPresenter, userId: Int, userName: String) {
        self.presenter  = presenter
        self.userId     = userId
        self.userName   = userName
        startPostTable()
    }
    
    private func startPostTable() {
        guard let userId = userId,
              let userName = userName else { return }
        self.presenter?.setViewDelegate(viewDelegate: self)
        self.presenter?.getAllPosts(userId: userId)
        navigationItem.title = "Álbuns de \(userName)"
    }
    
    private func errorPresent() {
        let alert = UIAlertController(title: "Erro", message: "Algo errado aconteceu. Tente novamente mais tarde.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { _ in
            alert.dismiss(animated: true)
        }))
        self.present(alert, animated: true)
    }
    
    func fillPosts(posts: [Post]?) {
        guard let posts = posts else {
            errorPresent()
            return
        }
        self.posts = posts
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TitleAndDescriptionCell", for: indexPath) as? TitleAndDescriptionTableViewCell else {
            return UITableViewCell()
        }

        let post = posts[indexPath.row]
        cell.titleLabel.text = post.title
        cell.descriptionLabel.text = post.body

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let postId = posts[indexPath.row].id
        guard let userName = userName else { return }
        self.presenter?.presentComment(postId: postId, name: userName)
    }
}
