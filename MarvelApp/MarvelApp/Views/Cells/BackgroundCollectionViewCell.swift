//
//  BackgroundCollectionViewCell.swift
//  MarvelApp
//
//  Created by Obed Garcia on 5/29/21.
//

import UIKit

class BackgroundCollectionViewCell: UICollectionViewCell {
    static let identifier = String(describing: BackgroundCollectionViewCell.self)
    private let imageView: UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        //imageView.layer.cornerRadius = 6
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
 
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = contentView.bounds
        layer.cornerRadius = 6
        clipsToBounds = true
    }
    
    func configure(with imageURL: String ) {
        imageView.sd_setImage(with: URL(string: imageURL), completed: nil)
    }
}
