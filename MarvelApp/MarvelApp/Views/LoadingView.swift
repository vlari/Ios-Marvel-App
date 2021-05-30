//
//  DataDetailView.swift
//  MarvelApp
//
//  Created by Obed Garcia on 5/28/21.
//

import UIKit

class LoadingView: UIView {
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.color = UIColor.Theme.primary
        return spinner
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.Theme.secondary
        addSubview(spinner)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.startAnimating()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
}
