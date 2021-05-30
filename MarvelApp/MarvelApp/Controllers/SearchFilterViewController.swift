//
//  SearchFilterViewController.swift
//  MarvelApp
//
//  Created by Obed Garcia on 5/24/21.
//

import UIKit

protocol SearchFilterViewControllerDelegate: AnyObject {
    func didSelectFilterOptions(forText: String, withOption: String )
}

class SearchFilterViewController: UIViewController {
    private let nameLabel: UILabel = {
        let view = UILabel()
        view.textColor = .white //UIColor.Theme.primary
        view.text = "Name"
        view.textAlignment = .left
        view.font = UIFont(name: "Roboto bold", size: 18)
        return view
    }()
    let nameTextField: UITextField = {
        let view = UITextField()
        view.layer.cornerRadius = 6
        view.backgroundColor = .white
        view.textAlignment = .center
        return view
    }()
    private let orderByLabel: UILabel = {
        let view = UILabel()
        view.textColor = .white //UIColor.Theme.primary
        view.text = "Order By"
        view.textAlignment = .left
        view.font = UIFont(name: "Roboto bold", size: 14)
        return view
    }()
    private let applyButton: UIButton = {
        let view = UIButton()
        view.backgroundColor = UIColor.Theme.primary
        view.tintColor = .white
        view.setTitle("Apply", for: .normal)
        view.layer.cornerRadius = 6
        view.addTarget(self, action: #selector(didTapApplyFilter), for: .touchUpInside)
        return view
    }()
    private var collectionView: UICollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: SearchFilterViewController.buildCollectionViewLayout()
    )
    var orderByValue = OrderBy.name.rawValue
    weak var filterDelegate: SearchFilterViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        view.addSubview(nameLabel)
        view.addSubview(nameTextField)
        view.addSubview(orderByLabel)
        view.addSubview(collectionView)
        view.addSubview(applyButton)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        orderByLabel.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        applyButton.translatesAutoresizingMaskIntoConstraints = false
        configureCollectionView()
    }
 
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: navigationController!.navigationBar.bottomAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            nameLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            nameLabel.heightAnchor.constraint(equalToConstant: 40)
        ])
        NSLayoutConstraint.activate([
            nameTextField.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 6),
            nameTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 24),
            nameTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            nameTextField.heightAnchor.constraint(equalToConstant: 40)
        ])
        NSLayoutConstraint.activate([
            orderByLabel.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 24),
            orderByLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            orderByLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            orderByLabel.heightAnchor.constraint(equalToConstant: 40)
        ])
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: orderByLabel.bottomAnchor, constant: 6),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            collectionView.heightAnchor.constraint(equalToConstant: 60)
        ])
        NSLayoutConstraint.activate([
            applyButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            applyButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            applyButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24),
            applyButton.heightAnchor.constraint(equalToConstant: 46)
        ])
    }
    
    private func configure() {
        view.backgroundColor = UIColor.Theme.secondary
        title = "Search filter"
        let dismissBarButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(didTapDismissButton))
        navigationItem.rightBarButtonItem = dismissBarButton
    }
    
    private func configureCollectionView() {
        collectionView.register(OptionCollectionViewCell.self, forCellWithReuseIdentifier: OptionCollectionViewCell.identifier)
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
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.6), heightDimension: .absolute(46))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: sectonPadding, leading: sectonPadding, bottom: sectonPadding, trailing: sectonPadding)
        section.orthogonalScrollingBehavior = .groupPaging
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    @objc private func didTapDismissButton() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func didTapApplyFilter() {
        var searchText = ""
        if let text = nameTextField.text,
           !text.isEmpty {
            searchText = text
        }
        
        filterDelegate?.didSelectFilterOptions(forText: searchText, withOption: orderByValue)
        dismiss(animated: true, completion: nil)
    }
}

extension SearchFilterViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return OrderBy.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OptionCollectionViewCell.identifier, for: indexPath) as? OptionCollectionViewCell else { return UICollectionViewCell() }
        let option = OrderBy.allCases[indexPath.item].rawValue
        cell.configure(withOption: option)
        collectionView.selectItem(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .right)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? OptionCollectionViewCell {
            orderByValue = cell.titleLabel.text!
        }
    }
}
