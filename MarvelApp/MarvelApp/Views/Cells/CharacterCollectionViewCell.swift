//
//  CharacterCollectionViewCell.swift
//  MarvelApp
//
//  Created by Obed Garcia on 5/25/21.
//

import UIKit
import SDWebImage

class CharacterCollectionViewCell: UICollectionViewCell {
    static let identifier = String(describing: CharacterCollectionViewCell.self)
    private let characterImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.image = UIImage(systemName: "photo")
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 6
        return imageView
    }()
    
    private let characterNameLabel: UILabel = {
       let label = UILabel()
        label.minimumScaleFactor = 0.10
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont(name: "Roboto-Bold", size: 14)
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = UIColor.Theme.secondary
        contentView.addSubview(characterImageView)
        contentView.addSubview(characterNameLabel)
        contentView.clipsToBounds = clipsToBounds
        characterNameLabel.translatesAutoresizingMaskIntoConstraints = false
        characterImageView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        characterImageView.image = nil
        characterNameLabel.text = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        characterNameLabel.sizeToFit()
        
        NSLayoutConstraint.activate([
            characterImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            characterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            characterImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 5),
            characterImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 10)
        ])
        
        NSLayoutConstraint.activate([
            characterNameLabel.topAnchor.constraint(equalTo: characterImageView.bottomAnchor, constant: 10),
            characterNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            characterNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            characterNameLabel.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    func configure(with viewModel: CharacterCellViewModel) {
        let url = ImageHelper.getURLPath(for: viewModel.image, withSize: ImageConstant.squareMedium)
        characterImageView.sd_setImage(with: URL(string: url), completed: nil)
        characterNameLabel.text = viewModel.name
    }
}
