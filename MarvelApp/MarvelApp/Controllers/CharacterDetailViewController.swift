//
//  CharacterDetailViewController.swift
//  MarvelApp
//
//  Created by Obed Garcia on 5/24/21.
//

import UIKit

class CharacterViewController: UIViewController {
    private let character: CharacterViewModel
    private let characterImage: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()
    private let nameLabel: UILabel = {
        let view = UILabel()
        view.textColor = UIColor.Theme.primary
        view.textAlignment = .center
        view.numberOfLines = 0
        view.font = UIFont(name: "Roboto bold", size: 18)
        return view
    }()
    private let containerView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configure()
        addViews()
    }
    
    init(character: CharacterViewModel) {
        self.character = character
        nameLabel.text = character.name
        let imageUrl = ImageHelper.getURLPath(for: character.image, withSize: ImageConstant.squareLarge)
        characterImage.sd_setImage(with: URL(string: imageUrl), completed: nil)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.view.backgroundColor = .clear
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        NSLayoutConstraint.activate([
            characterImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            characterImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            characterImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            characterImage.heightAnchor.constraint(equalTo: characterImage.widthAnchor)
        ])
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: characterImage.bottomAnchor, constant: -20),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
//        NSLayoutConstraint.activate([
//            nameLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8),
//            nameLabel.leadingAnchor.constraint(equalTo: conta.leadingAnchor),
//            nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            nameLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
//        ])
    }
    
    private func configure() {
        view.backgroundColor = UIColor.Theme.secondary
    }
    
    private func addViews() {
        view.addSubview(characterImage)
        view.addSubview(containerView)
        view.addSubview(nameLabel)
        
        containerView.backgroundColor = .systemTeal
        characterImage.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.translatesAutoresizingMaskIntoConstraints = false
    }
}
