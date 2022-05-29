//
//  RootTabViewController.swift
//  iTunesPractice
//
//  Created by Serge Rylko on 26.05.22.
//

import Combine
import UIKit

class RootTabVC: UITabBarController {

    private let viewModel: RootTabVM
    private var cancellables = Set<AnyCancellable>()
    
    init(viewModel: RootTabVM) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupControllers()
        setupBinding()
    }
    
    private func setupUI() {
        tabBar.backgroundColor = .systemGray6
    }
    
    private func setupControllers() {
        let searchVM = viewModel.getSearchViewModel()
        let searchVC = wrapNavigation(SearchVC(viewModel: searchVM))
        searchVC.navigationController?.navigationBar.backgroundColor = .white
        searchVC.tabBarItem = .init(title: viewModel.getSearchTitle(),
                                            image: .init(named: "tabbar_search"),
                                            selectedImage: nil)
        
        let favouritesVM = viewModel.getFavouritesViewModel()
        let favouritesVC = wrapNavigation(FavouritesVC(viewModel: favouritesVM))
        favouritesVC.tabBarItem = .init(title: viewModel.getFavouritesTitle(),
                                        image: .init(named: "tabbar_favourites"),
                                        selectedImage: nil)
        
        setViewControllers([searchVC, favouritesVC], animated: false)
    }
    
    private func setupBinding() {
        setupBadgeBinding()
    }
    
    private func setupBadgeBinding() {
        guard
            let favouritesVC = viewControllers?[safe: 1],
            let tabBarItem = favouritesVC.tabBarItem else { return }
        
        viewModel.$badgeValue
            .assign(to: \.badgeValue, on: tabBarItem)
            .store(in: &cancellables)
    }
    
    private func wrapNavigation(_ controller: UIViewController) -> UIViewController {
        UINavigationController(rootViewController: controller)
    }
}
