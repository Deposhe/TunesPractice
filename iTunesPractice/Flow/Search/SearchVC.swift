//
//  NextViewController.swift
//  iTunesPractice
//
//  Created by Serge Rylko on 24.05.22.
//

import Combine
import UIKit

final class SearchVC: UIViewController {

    private enum Section: CaseIterable {
        case search
    }
    
    private let searchBar = UISearchBar()
    private let mediaControl = FilterControl()
    private let tableView = UITableView()
    private lazy var dataSource = makeDataSource()
    
    private var cancellables = Set<AnyCancellable>()
    
    private let viewModel: SearchVM

    init(viewModel: SearchVM) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupConstaints()
        setupBinding()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
  
        navigationItem.titleView = searchBar
        searchBar.delegate = self
 
        mediaControl.backgroundColor = .white
        view.addSubview(mediaControl)

        tableView.register(SearchResultCell.self, forCellReuseIdentifier: SearchResultCell.reuseID)
        tableView.dataSource = dataSource
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.rowHeight = UITableView.automaticDimension
        view.addSubview(tableView) 
    }
    
    private func setupConstaints() {
        [mediaControl, tableView].forEach{ $0.translatesAutoresizingMaskIntoConstraints = false }
        
        NSLayoutConstraint.activate([
            mediaControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mediaControl.heightAnchor.constraint(equalToConstant: 44.0),
            mediaControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mediaControl.widthAnchor.constraint(greaterThanOrEqualToConstant: 300),
            
            tableView.topAnchor.constraint(equalTo: mediaControl.bottomAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setupBinding() {
        viewModel.$cellViewModels
            .sink { [weak self] viewModels in
                self?.update(by: viewModels)
            }.store(in: &cancellables)
        
        viewModel.$mediaTitles
            .map({ $0 })
            .assign(to: \.items, on: mediaControl)
            .store(in: &cancellables)
        
        searchBar.textPublisher
            .assign(to: &viewModel.$searchText)
        
        mediaControl.$selectedItems
            .assign(to: &viewModel.$selectedMediaTypeIndexes)
        
        keyboardApeparance()
            .sink { [weak self] offset in
                guard let self = self else { return }
                self.adjust(scrollView: self.tableView, by: offset)
            }.store(in: &cancellables)
    }
    
    private func makeDataSource() -> UITableViewDiffableDataSource<Section, SearchResultCellVM> {
        let source = UITableViewDiffableDataSource<Section, SearchResultCellVM>(tableView: tableView) { tableView, indexPath, viewModel in
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultCell.reuseID, for: indexPath) as? SearchResultCell else {
                assertionFailure("Failed to dequeue")
                return UITableViewCell()
            }
            cell.viewModel = viewModel
            return cell
        }
        source.defaultRowAnimation = .fade
        
        return source
    }
    
    private func update(by cellModels: [SearchResultCellVM]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, SearchResultCellVM>()
        snapshot.appendSections(Section.allCases)
        snapshot.appendItems(cellModels, toSection: .search)
        dataSource.apply(snapshot, animatingDifferences: true, completion: nil)
    }
}

extension SearchVC: UITableViewDelegate { }

extension SearchVC: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchBar.resignFirstResponder()
    }
}

extension SearchVC: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
