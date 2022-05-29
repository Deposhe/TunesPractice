//
//  SearchResultCell.swift
//  iTunesPractice
//
//  Created by Serge Rylko on 24.05.22.
//

import Combine
import Kingfisher
import UIKit

final class SearchResultCell: UITableViewCell {

    static let reuseID = "SearchResultCell"
    
    private let iconImageView = UIImageView()
    private let titleLabel = UILabel()
    private let favouritesButton = FavouriteButton()
    private var cancellables = Set<AnyCancellable>()
    
    var viewModel: SearchResultCellVM! {
        didSet {
            setupBinding()
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
        setupContraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupBinding() {
        viewModel.$title
            .assign(to: \.text , on: titleLabel)
            .store(in: &cancellables)
        
        viewModel.$isFavourite
            .assign(to: \.isSelected, on: favouritesButton)
            .store(in: &cancellables)
        
        viewModel.$imageURL.sink { [unowned self] url in
            self.setImage(url: url)
        }.store(in: &cancellables)
    }
    
    private func setupUI() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(iconImageView)
        contentView.addSubview(favouritesButton)
        
        iconImageView.backgroundColor = .gray
        iconImageView.clipsToBounds = true
        iconImageView.contentMode = .scaleAspectFill
        iconImageView.layer.cornerRadius = 3.0
        
        titleLabel.numberOfLines = 0
        
        favouritesButton.addTarget(self, action: #selector(didPressFavouriteButton(_:)), for: .touchUpInside)
    }
    
    private func setupContraints() {
        [titleLabel, iconImageView, favouritesButton]
            .forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        NSLayoutConstraint.activate([
            iconImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 5.0),
            iconImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5.0),
            iconImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 60.0),
            iconImageView.heightAnchor.constraint(equalTo: iconImageView.widthAnchor),
            
            titleLabel.leftAnchor.constraint(equalTo: iconImageView.rightAnchor, constant: 5.0),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5.0),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

            favouritesButton.leftAnchor.constraint(equalTo: titleLabel.rightAnchor, constant: 5.0),
            favouritesButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            favouritesButton.widthAnchor.constraint(equalToConstant: 40.0),
            favouritesButton.heightAnchor.constraint(equalTo: favouritesButton.widthAnchor),
            favouritesButton.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10.0),
        ])
    }
    
    @objc private func didPressFavouriteButton(_ sender: UIButton) {
        viewModel.didPressFavouriteButton()
    }
    
    private func setImage(url: URL) {
        iconImageView.kf.setImage(with: url, options: [.transition(.fade(0.2))])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        iconImageView.kf.cancelDownloadTask()
        iconImageView.image = nil
        cancellables.forEach({ $0.cancel() })
        cancellables.removeAll()
    }
}
