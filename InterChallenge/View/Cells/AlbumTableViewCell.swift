import UIKit

class AlbumTableViewCell: UITableViewCell {
    
    static let identifierCell = "AlbumTableViewCell"

    lazy var albumNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 17)
        label.numberOfLines = 3
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        hierarchyView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func hierarchyView() {
        addSubview(albumNameLabel)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            albumNameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            albumNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            albumNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            albumNameLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        ])
    }
    
}
