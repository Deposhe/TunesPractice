//
//  FavouritesVC.swift
//  iTunesPractice
//
//  Created by Serge Rylko on 26.05.22.
//

import Combine
import Foundation
import UIKit

final class FavouritesVC: UIViewController {
    
    private enum Section: CaseIterable {
        case favourites
    }
    
    private let tableView = UITableView()
    private lazy var dataSource = makeDataSource()
    
    private var cancellables = Set<AnyCancellable>()
    
    private let viewModel: FavouritesVM
    
    init(viewModel: FavouritesVM) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Favourites"
        
        setupUI()
        setupConstraints()
        setupBinding()
    }
    
    func setupUI() {
        view.backgroundColor = .white
        
        tableView.register(FavouriteCell.self, forCellReuseIdentifier: FavouriteCell.reuseID)
        
        tableView.dataSource = dataSource
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.rowHeight = UITableView.automaticDimension
        view.addSubview(tableView)
    }
    
    private func setupConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setupBinding() {
        viewModel.$cellViewModels
            .sink { [unowned self] viewModels in
                self.update(by: viewModels)
            }.store(in: &cancellables)
        
        viewModel.removeConfirmation
            .sink(receiveValue: { [unowned self] resolver in
                self.presentRemoveConfirmation(resolver: resolver)
            }).store(in: &cancellables)
    }
    
    private func makeDataSource() -> UITableViewDiffableDataSource<Section, FavouriteCellVM> {
        let source = UITableViewDiffableDataSource<Section, FavouriteCellVM>(tableView: tableView) { tableView, indexPath, viewModel in
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: FavouriteCell.reuseID, for: indexPath) as? FavouriteCell else {
                assertionFailure("Failed to dequeue")
                return UITableViewCell()
            }
            cell.viewModel = viewModel
            return cell
        }
        source.defaultRowAnimation = .fade
        
        return source
    }
    
    private func update(by cellModels: [FavouriteCellVM]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, FavouriteCellVM>()
        snapshot.appendSections(Section.allCases)
        snapshot.appendItems(cellModels, toSection: .favourites)
        dataSource.apply(snapshot, animatingDifferences: true, completion: nil)
    }
    
    private func presentRemoveConfirmation(resolver: @escaping FavouritesVM.RemoveConfirmation) {
        let alertVC = UIAlertController(title: viewModel.alertTitleText(),
                                        message: viewModel.alertMessageText(),
                                        preferredStyle: .alert)
        let actionRemove = UIAlertAction(title: viewModel.alertRemoveText(), style: .destructive) { _ in
            resolver(true)
        }
        let actionCancel = UIAlertAction(title: viewModel.alertCancelText(), style: .cancel) { _ in
            resolver(false)
            alertVC.dismiss(animated: true, completion: nil)
        }
        alertVC.addAction(actionRemove)
        alertVC.addAction(actionCancel)
        
        present(alertVC, animated: true, completion: nil)
    }
}
