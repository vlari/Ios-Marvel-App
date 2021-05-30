//
//  SearchViewController.swift
//  MarvelApp
//
//  Created by Obed Garcia on 5/24/21.
//

import UIKit

class SearchViewController: UIViewController {
    private var cellViewModels: [CharacterCellViewModel] = []
    private var characterViewModels: [CharacterViewModel] = []
    private var currentPage = 0
    private var isLoading = false
    private var loadingReusableView: LoadingReusableView?
    let searchController: UISearchController = {
        let view = UISearchController(searchResultsController: nil)
        view.searchBar.placeholder = "Search character"
        view.searchBar.searchBarStyle = .prominent
        view.definesPresentationContext = true
        view.searchBar.searchTextField.backgroundColor = .white
        view.obscuresBackgroundDuringPresentation = false
        return view
    }()
    private var filterText = ""
    private var collectionView: UICollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: SearchViewController.buildCollectionViewLayout()
    )
    private var orderByOption = OrderBy.name.rawValue
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        fetchData()
        configureCollectionView()    
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
    
    private func fetchData() {
        isLoading = true
        APIManager.shared.getCharacters(forPage: currentPage, withName: filterText, orderBy: orderByOption) { [weak self] result in
            switch result {
            case .success(let model):
                guard let self = self else { return }
                let hasResults = model.data.results.count > 0
                guard hasResults else { return }
                let characterResponse = model.data.results
                self.cellViewModels.append(contentsOf: characterResponse.compactMap({
                    return CharacterCellViewModel(name: $0.name, image: $0.thumbnail)
                }))
                self.characterViewModels.append(contentsOf: characterResponse.compactMap({
                    return CharacterViewModel(id: $0.id ,name: $0.name, image: $0.thumbnail,
                                              series: $0.series, stories: $0.series,
                                              events: $0.events, comics: $0.comics)
                }))
                
                DispatchQueue.main.async {
                    if model.data.total > APIManager.shared.pageLimit {
                        self.currentPage += 1
                        self.loadingReusableView?.activityIndicator.stopAnimating()
                    }
                    self.collectionView.reloadData()
                    self.isLoading = false
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func configureCollectionView() {
        view.addSubview(collectionView)
        collectionView.register(CharacterCollectionViewCell.self, forCellWithReuseIdentifier: CharacterCollectionViewCell.identifier)
        collectionView.register(LoadingReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: LoadingReusableView.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.Theme.secondary
    }
    
    private static func buildCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        let sectonPadding: CGFloat = 10
        let itemPadding: CGFloat = 8
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(2/3))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: itemPadding, bottom: itemPadding, trailing: itemPadding)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(2/3))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item, item])
        
        let footerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(55))
        let sectionFooter = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: footerSize, elementKind: UICollectionView.elementKindSectionFooter, alignment: .bottom)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: sectonPadding, leading: sectonPadding, bottom: sectonPadding, trailing: sectonPadding)
        section.boundarySupplementaryItems = [sectionFooter]
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    private func configure() {
        title = "Marvel World"
        view.backgroundColor = UIColor.Theme.secondary
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        let filterBarButton = UIBarButtonItem(image: UIImage(systemName: "slider.horizontal.3"), style: .plain, target: self, action: #selector(didTapFilterButton))
        navigationItem.rightBarButtonItem = filterBarButton
    }
    
    @objc private func didTapFilterButton() {
        let vc = SearchFilterViewController()
        vc.filterDelegate = self
        vc.nameTextField.text = filterText
        vc.orderByValue = orderByOption
        let navVC = UINavigationController(rootViewController: vc)
        navVC.navigationBar.prefersLargeTitles = true
        navVC.viewControllers.first?.navigationItem.largeTitleDisplayMode = .always
        present(navVC, animated: true, completion: nil)
    }
    
    private func resetItems() {
        self.cellViewModels = []
        self.characterViewModels = []
        self.currentPage = 0
    }
}

// MARK: - CollectionView
extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellViewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CharacterCollectionViewCell.identifier, for: indexPath)
                as? CharacterCollectionViewCell else { return UICollectionViewCell() }
        let character = cellViewModels[indexPath.item]
        cell.configure(with: character)
        return cell
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        guard !isLoading else { return }
        guard self.filterText.isEmpty else { return }
        let offset = scrollView.contentOffset.y
        let height = scrollView.contentSize.height

        if offset > height - scrollView.frame.size.height {
            loadingReusableView?.activityIndicator.startAnimating()
            fetchData()
        }
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionFooter {
            guard let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: LoadingReusableView.identifier, for: indexPath) as? LoadingReusableView else { return UICollectionReusableView() }
            loadingReusableView = footerView
            loadingReusableView?.backgroundColor = UIColor.clear
            return footerView
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let character = characterViewModels[indexPath.item]
        let vc = CharacterViewController(character: character)
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - SearchBar Delegate
extension SearchViewController: UISearchBarDelegate, UISearchResultsUpdating{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text,
              !searchText.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        self.filterText = searchText
        resetItems()
        fetchData()
    }
    func updateSearchResults(for searchController: UISearchController) {
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    }
}

extension SearchViewController: SearchFilterViewControllerDelegate {
    func didSelectFilterOptions(forText: String, withOption: String) {
        self.filterText = forText
        searchController.searchBar.text = self.filterText
        orderByOption = withOption
        fetchData()
    }
}
