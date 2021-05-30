//
//  ComicHeaderReusableView.swift
//  MarvelApp
//
//  Created by Obed Garcia on 5/29/21.
//

import UIKit

class ComicHeaderReusableView: UICollectionReusableView {
    static let identifier = String(describing: ComicHeaderReusableView.self)
    private let headerLabel: UILabel = {
       let label = UILabel()
        label.textColor = UIColor.Theme.primary
        label.textAlignment = .left
        label.font = UIFont(name: "Roboto-BoldCondensed", size: 18)
        return label
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.Theme.secondary
        addSubview(headerLabel)
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with text: String) {
        headerLabel.text = text
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: self.topAnchor),
            headerLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            headerLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            headerLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
