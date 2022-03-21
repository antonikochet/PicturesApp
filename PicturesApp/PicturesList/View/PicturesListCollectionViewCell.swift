//
//  PicturesListCollectionViewCell.swift
//  PicturesApp
//
//  Created by Антон Кочетков on 15.03.2022.
//

import UIKit

protocol PicturesListCellViewModelType {
    var photographer: String { get }
    var description: String? { get }
    var loadImage: ((Data?) -> Void)? { get set }
    var startLoadImage: ((PicturesListCellViewModelType) -> Void)? { get set }
}

class PicturesListCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "PicturesListCollectionViewCell"
    
    private static let photographerFont: UIFont = UIFont.systemFont(ofSize: 16, weight: .semibold)
    private var viewModel: PicturesListCellViewModelType?
    
    private let pictureImageView: UIImageView = {
        let image = UIImageView()
        image.backgroundColor = .gray
        image.contentMode = .scaleAspectFill
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.alpha = 0.6
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let photographerLabel: UILabel = {
        let label = UILabel()
        label.contentMode = .left
        label.font = photographerFont
        label.textColor = .black
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.contentMode = .left
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 0
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(pictureImageView)
        pictureImageView.addSubview(containerView)
        containerView.addSubview(photographerLabel)
        containerView.addSubview(descriptionLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        NSLayoutConstraint.activate([
            pictureImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            pictureImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            pictureImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            pictureImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            containerView.leadingAnchor.constraint(equalTo: pictureImageView.leadingAnchor, constant: 4),
            containerView.trailingAnchor.constraint(equalTo: pictureImageView.trailingAnchor, constant: -4),
            containerView.bottomAnchor.constraint(equalTo: pictureImageView.bottomAnchor, constant: -4),
            containerView.heightAnchor.constraint(equalTo: pictureImageView.heightAnchor, multiplier: 0.3),
            
            photographerLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 4),
            photographerLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 4),
            photographerLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -4),
            
            descriptionLabel.topAnchor.constraint(equalTo: photographerLabel.bottomAnchor, constant: 2),
            descriptionLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 4),
            descriptionLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -4),
            descriptionLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -2)
        ])
        
        pictureImageView.layer.masksToBounds = true
        pictureImageView.layer.cornerRadius = 10
        
        containerView.layer.masksToBounds = true
        containerView.layer.cornerRadius = 6
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        viewModel = nil
        pictureImageView.image = nil
        photographerLabel.text = ""
        descriptionLabel.text = ""
    }
    
    func set( viewModel: PicturesListCellViewModelType) {
        self.viewModel = viewModel
        self.viewModel?.loadImage = { [weak self] data in
            guard let data = data else { return }
            DispatchQueue.main.async {
                self?.pictureImageView.image = UIImage(data: data)
            }
        }
        viewModel.startLoadImage?(viewModel)
        photographerLabel.text = viewModel.photographer
        if let description = viewModel.description,
           !description.isEmpty {
            descriptionLabel.text = description
        }
    }
}
