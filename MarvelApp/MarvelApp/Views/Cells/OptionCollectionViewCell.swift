//
//  OptionCollectionViewCell.swift
//  MarvelApp
//
//  Created by Obed Garcia on 5/27/21.
//

import UIKit

class OptionCollectionViewCell: UICollectionViewCell {
    static let identifier = String(describing: OptionCollectionViewCell.self)
    let titleLabel: UILabel = {
        let view = UILabel()
        view.textColor = UIColor.Theme.primary
        view.textAlignment = .center
        view.font = UIFont(name: "Roboto-BoldCondensed", size: 14)
        return view
    }()
    
    override var isSelected: Bool{
            didSet{
                if self.isSelected
                {
                    super.isSelected = true
                    self.applySelectedStyle(when: true)
                }
                else
                {
                    super.isSelected = false
                    self.applySelectedStyle(when: false)
                }
            }
        }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = 20
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    func configure(withOption option: String) {
        titleLabel.text = option
    }
    
    func applySelectedStyle(when selected: Bool) {
        backgroundColor = selected ? UIColor.Theme.primary : .white
        titleLabel.textColor = selected ? .white : UIColor.Theme.primary
    }
}
