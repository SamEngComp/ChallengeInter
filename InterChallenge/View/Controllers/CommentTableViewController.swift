import Alamofire
import UIKit

class CommentTableViewController: UITableViewController, CommentViewDelegate {
    
    private var postId: Int?
    private var name: String?
    private var comments = [Comment]()
    private var presenter: CommentPresenter?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(TitleAndDescriptionTableViewCell.self, forCellReuseIdentifier: TitleAndDescriptionTableViewCell.identifierCell)
    }
    
    func setupComment(presenter: CommentPresenter, postId: Int, name: String) {
        self.presenter  = presenter
        self.postId     = postId
        self.name   = name
        startCommentTable()
    }
    
    private func startCommentTable() {
        guard let postId = postId,
              let name = name else { return }
        self.presenter?.setViewDelegate(viewDelegate: self)
        self.presenter?.getAllComments(postId: postId)
        navigationItem.title = "Comentários de \(name)"
    }
    
    func fillComments(comments: [Comment]) {
        self.comments = comments
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
        return comments.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleAndDescriptionTableViewCell.identifierCell, for: indexPath) as? TitleAndDescriptionTableViewCell else {
            return UITableViewCell()
        }

        let comment = comments[indexPath.row]
        cell.selectionStyle = .none
        cell.titleLabel.text = comment.name
        cell.descriptionLabel.text = comment.body

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 230
    }
}
