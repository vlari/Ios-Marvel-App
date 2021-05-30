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
        view.textColor = .white
        view.textAlignment = .center
        view.numberOfLines = 0
        view.font = UIFont(name: "Roboto-Bold", size: 24)
        return view
    }()
    private var collectionView: UICollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: CharacterViewController.buildCollectionViewLayout()
    )
    private var currentPage = 0
    private let containerView = UIView()
    private var comics: [Comic] = []
    private var loadingView = LoadingView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.Theme.secondary
        configureCollectionView()
        addViews()
        addLoadingView()
    }
    
    init(character: CharacterViewModel) {
        self.character = character
        self.nameLabel.text = character.name
        let imageUrl = ImageHelper.getURLPath(for: character.image, withSize: ImageConstant.squareLarge)
        characterImage.sd_setImage(with: URL(string: imageUrl), completed: nil)
        super.init(nibName: nil, bundle: nil)
        self.fetchData()
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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.view.backgroundColor = UIColor.Theme.secondary
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        NSLayoutConstraint.activate([
            characterImage.topAnchor.constraint(equalTo: view.topAnchor),
            characterImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            characterImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            characterImage.heightAnchor.constraint(equalTo: characterImage.widthAnchor)
        ])
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: characterImage.bottomAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            nameLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            nameLabel.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    private func configureCollectionView() {
        collectionView.register(BackgroundCollectionViewCell.self, forCellWithReuseIdentifier: BackgroundCollectionViewCell.identifier)
        collectionView.register(ComicHeaderReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: ComicHeaderReusableView.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.Theme.secondary
    }
    
    private static func buildCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        let sectonPadding: CGFloat = 10
        let itemPadding: CGFloat = 8
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: itemPadding, bottom: itemPadding, trailing: itemPadding)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.6), heightDimension: .fractionalWidth(0.8))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item, item])
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: sectonPadding, leading: sectonPadding, bottom: sectonPadding, trailing: sectonPadding)
        section.orthogonalScrollingBehavior = .groupPaging
        section.boundarySupplementaryItems = [sectionHeader]
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    private func fetchData() {
        APIManager.shared.getComics(from: character.id, forPage: currentPage) { [weak self] result in
            
            switch result {
            case .success(let model):
                guard let self = self else { return }
                self.comics = model.data.results
                DispatchQueue.main.async {
                    self.loadingView.removeFromSuperview()
                    self.addCollectionView()
                    self.collectionView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func addViews() {
        view.addSubview(characterImage)
        view.addSubview(nameLabel)
        characterImage.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func addCollectionView() {
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func addLoadingView() {
        view.addSubview(loadingView)
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            loadingView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor),
            loadingView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            loadingView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            loadingView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
    }
}

extension CharacterViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return comics.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BackgroundCollectionViewCell.identifier, for: indexPath)
                as? BackgroundCollectionViewCell else { return UICollectionViewCell() }
        let thumbnail = comics[indexPath.item].thumbnail
        let url = ImageHelper.getURLPath(for: thumbnail, withSize: .portrait)
        cell.configure(with: url)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ComicHeaderReusableView.identifier, for: indexPath) as? ComicHeaderReusableView else { return UICollectionReusableView() }
            header.configure(with: "Comics")
            return header
        }
        return UICollectionReusableView()
    }
}
