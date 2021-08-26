import Alamofire
import UIKit

class CommentTableViewController: UITableViewController, CommentViewDelegate {
    
    private var postId: Int?
    private var userName: String?
    private var comments = [Comment]()
    private var presenter: CommentPresenter?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "TitleAndDescriptionTableViewCell", bundle: nil),
                           forCellReuseIdentifier: "TitleAndDescriptionCell")
    }
    
    func setupComment(presenter: CommentPresenter, postId: Int, userName: String) {
        self.presenter  = presenter
        self.postId     = postId
        self.userName   = userName
        startCommentTable()
    }
    
    private func startCommentTable() {
        guard let postId = postId,
              let userName = userName else { return }
        self.presenter?.setViewDelegate(viewDelegate: self)
        self.presenter?.getAllComments(postId: postId)
        navigationItem.title = "Comentários de \(userName)"
    }
    
    func fillComments(comments: [Comment]?) {
        guard let comments = comments else {
            errorPresent()
            return
        }
        self.comments = comments
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
        return comments.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TitleAndDescriptionCell", for: indexPath) as? TitleAndDescriptionTableViewCell else {
            return UITableViewCell()
        }

        let comment = comments[indexPath.row]
        cell.selectionStyle = .none
        cell.titleLabel.text = comment.name
        cell.descriptionLabel.text = comment.body

        return cell
    }
}
