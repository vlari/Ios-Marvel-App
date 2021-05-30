//
//  LoadingReusableView.swift
//  MarvelApp
//
//  Created by Obed Garcia on 5/26/21.
//

import UIKit

class LoadingReusableView: UICollectionReusableView {
    static let identifier = String(describing: LoadingReusableView.self)
    let activityIndicator: UIActivityIndicatorView = {
       let view = UIActivityIndicatorView()
        view.style = .medium
        view.color = UIColor.Theme.primary
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureIndicator()
        backgroundColor = .systemTeal
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureIndicator() {
        addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
}
