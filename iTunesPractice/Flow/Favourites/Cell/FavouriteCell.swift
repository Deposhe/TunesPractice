//
//  FavouriteCell.swift
//  iTunesPractice
//
//  Created by Serge Rylko on 27.05.22.
//

import Combine
import UIKit

final class FavouriteCell: UITableViewCell {

    static let reuseID = "FavouriteCell"
    
    private let iconImageView = UIImageView()
    private let titleLabel = UILabel()
    private let removeButton = FavouriteButton()
    private var cancellables = Set<AnyCancellable>()
    
    var viewModel: FavouriteCellVM! {
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
    
    private func setupUI() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(iconImageView)
        contentView.addSubview(removeButton)
        
        iconImageView.backgroundColor = .gray
        iconImageView.clipsToBounds = true
        iconImageView.contentMode = .scaleAspectFill
        iconImageView.layer.cornerRadius = 3.0
        
        titleLabel.numberOfLines = 0
        
        removeButton.setImage(.init(named: "btn_remove"), for: .normal)
        removeButton.addTarget(self, action: #selector(didPressRemoveButton(_:)), for: .touchUpInside)
    }
    
    private func setupContraints() {
        [titleLabel, iconImageView, removeButton]
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
            
            removeButton.leftAnchor.constraint(equalTo: titleLabel.rightAnchor, constant: 5.0),
            removeButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            removeButton.widthAnchor.constraint(equalToConstant: 35.0),
            removeButton.heightAnchor.constraint(equalTo: removeButton.widthAnchor),
            removeButton.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20.0),
        ])
    }
    
    private func setupBinding() {
        viewModel.$title
            .assign(to: \.text , on: titleLabel)
            .store(in: &cancellables)

        viewModel.$imageData
            .compactMap({ $0 })
            .map({ UIImage(data: $0) })
            .assign(to: \.image, on: iconImageView)
            .store(in: &cancellables)
    }
    
    @objc private func didPressRemoveButton(_ sender: Any) {
        viewModel.didTapRemoveFavourite()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        iconImageView.image = nil
        cancellables.forEach({ $0.cancel() })
        cancellables.removeAll()
    }
}
