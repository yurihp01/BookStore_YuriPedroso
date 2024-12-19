import UIKit

class BookCell: UITableViewCell {
    // MARK: - Vars & Views

    static let identifier = "BookCell"
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var imageViewThumbnail: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleToFill
        return imageView
    }()
        
    // MARK: - inits & setup cell
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(titleLabel)
        contentView.addSubview(imageViewThumbnail)
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(title: String, thumbnail: UIImage?) {
        titleLabel.text = title
        imageViewThumbnail.image = thumbnail
    }
}

// MARK: - Private Extension
private extension BookCell {
    func configureConstraints() {
        NSLayoutConstraint.activate([
            imageViewThumbnail.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            imageViewThumbnail.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageViewThumbnail.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            imageViewThumbnail.widthAnchor.constraint(equalToConstant: 50),
            titleLabel.leadingAnchor.constraint(equalTo: imageViewThumbnail.trailingAnchor, constant: 15),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15)
        ])
    }
}
