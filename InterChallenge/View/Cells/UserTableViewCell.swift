import UIKit

protocol UserTableViewCellDelegate: AnyObject {
    func didTapAlbums(with userId: Int, by name: String)
    func didTapPosts(with userId: Int, by name: String)
}

class UserTableViewCell: UITableViewCell {
    
    static let identifierCell = "UserTableViewCell"
    
    lazy var initialsView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemYellow
        return view
    }()
    
    lazy var initialsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 17)
        label.textAlignment = .center
        return label
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 17)
        label.textAlignment = .center
        label.numberOfLines = 3
        return label
    }()
    
    lazy var separatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightGray
        return view
    }()
    
    lazy var userNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 17)
        label.numberOfLines = 2
        return label
    }()
    
    lazy var emailLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 17)
        label.numberOfLines = 2
        return label
    }()
    
    lazy var phoneLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 17)
        label.numberOfLines = 2
        return label
    }()
    
    lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    lazy var albumsButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(albumsAction(_:)), for: .touchUpInside)
        button.backgroundColor = .clear
        button.setTitle("ÁLBUNS", for: .normal)
        button.setTitleColor(.systemYellow, for: .normal)
        return button
    }()
    
    lazy var postsButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(postsAction(_:)), for: .touchUpInside)
        button.backgroundColor = .clear
        button.setTitle("POSTAGENS", for: .normal)
        button.setTitleColor(.systemYellow, for: .normal)
        return button
    }()
    
    var id: Int = 0
    var delegate: UserTableViewCellDelegate?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        hierarchyView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func albumsAction(_ sender: UIButton) {
        delegate?.didTapAlbums(with: id, by: nameLabel.text ?? "")
    }
    
    @objc func postsAction(_ sender: UIButton) {
        delegate?.didTapPosts(with: id, by: nameLabel.text ?? "")
    }
    
    func hierarchyView() {
        
        contentView.addSubview(initialsView)
        initialsView.addSubview(initialsLabel)
        contentView.addSubview(nameLabel)
        contentView.addSubview(separatorView)
        contentView.addSubview(userNameLabel)
        contentView.addSubview(emailLabel)
        contentView.addSubview(phoneLabel)
        contentView.addSubview(stackView)
        stackView.addSubview(albumsButton)
        stackView.addSubview(postsButton)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            initialsView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            initialsView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            initialsView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.4),
            initialsView.widthAnchor.constraint(equalTo: initialsView.heightAnchor),
            
            initialsLabel.topAnchor.constraint(equalTo: initialsView.topAnchor),
            initialsLabel.leadingAnchor.constraint(equalTo: initialsView.leadingAnchor),
            initialsLabel.trailingAnchor.constraint(equalTo: initialsView.trailingAnchor),
            initialsLabel.bottomAnchor.constraint(equalTo: initialsView.bottomAnchor),

            nameLabel.topAnchor.constraint(equalTo: initialsView.bottomAnchor, constant: 16),
            nameLabel.leadingAnchor.constraint(equalTo: initialsView.leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: initialsView.trailingAnchor),

            separatorView.widthAnchor.constraint(equalToConstant: 2),
            separatorView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            separatorView.bottomAnchor.constraint(equalTo: stackView.topAnchor, constant: -24),
            separatorView.leadingAnchor.constraint(equalTo: initialsView.trailingAnchor, constant: 32),

            userNameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            userNameLabel.leadingAnchor.constraint(equalTo: separatorView.trailingAnchor, constant: 16),
            userNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),

            emailLabel.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 24),
            emailLabel.leadingAnchor.constraint(equalTo: userNameLabel.leadingAnchor),
            emailLabel.trailingAnchor.constraint(equalTo: userNameLabel.trailingAnchor),

            phoneLabel.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 24),
            phoneLabel.leadingAnchor.constraint(equalTo: userNameLabel.leadingAnchor),
            phoneLabel.trailingAnchor.constraint(equalTo: userNameLabel.trailingAnchor),
            
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            stackView.leadingAnchor.constraint(equalTo: initialsView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: userNameLabel.trailingAnchor),
            stackView.heightAnchor.constraint(equalToConstant: 35),
            
            albumsButton.topAnchor.constraint(equalTo: stackView.topAnchor),
            albumsButton.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            albumsButton.bottomAnchor.constraint(equalTo: stackView.bottomAnchor),
            albumsButton.trailingAnchor.constraint(equalTo: stackView.centerXAnchor),
            
            postsButton.topAnchor.constraint(equalTo: stackView.topAnchor),
            postsButton.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            postsButton.bottomAnchor.constraint(equalTo: stackView.bottomAnchor),
            postsButton.leadingAnchor.constraint(equalTo: stackView.centerXAnchor),
        ])
    }
}
