//
//  PicturesDetailViewController.swift
//  PicturesApp
//
//  Created by Антон Кочетков on 20.03.2022.
//

import UIKit

protocol PicturesDetailViewModelType {
    var loadImage: ((Data?) -> Void)? { get set }
    var loadImageStart: (() -> Void)? { get set }
    var dataDidLoad: ((PicturesDetailViewModelType) -> Void)? { get set }
    func showData()
    
    var width: Int { get }
    var height: Int { get }
    var photographer: String { get }
    var description: String? { get }
    var dateLoad: String { get }
}

class PicturesDetailViewController: UIViewController {

    var viewModel: PicturesDetailViewModelType!
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let actIndicator = UIActivityIndicatorView()
        actIndicator.hidesWhenStopped = true
        return actIndicator
    }()
    
    private let photographerLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let dateLoadLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .thin)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(white: 0.8, alpha: 1)
        navigationItem.title = "Detail"
        view.addSubview(imageView)
        view.addSubview(activityIndicator)
        view.addSubview(photographerLabel)
        view.addSubview(dateLoadLabel)
        view.addSubview(descriptionLabel)
        configureViewModel()
        viewModel.showData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        activityIndicator.center = view.center
        
        NSLayoutConstraint.activate([
            photographerLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16),
            photographerLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            photographerLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            photographerLabel.heightAnchor.constraint(equalToConstant: UIFont.systemFont(ofSize: 16).lineHeight),
        
            dateLoadLabel.topAnchor.constraint(equalTo: photographerLabel.bottomAnchor, constant: 4),
            dateLoadLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            dateLoadLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            dateLoadLabel.heightAnchor.constraint(equalToConstant: UIFont.systemFont(ofSize: 16).lineHeight),
        
            descriptionLabel.topAnchor.constraint(equalTo: dateLoadLabel.bottomAnchor, constant: 4),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    private func configureViewModel() {
        viewModel.loadImage = { [weak self] data in
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
                guard let data = data else {
                    self?.imageView.image = nil
                    return
                }
                self?.imageView.image = UIImage(data: data)
                self?.dateLoadLabel.text = self?.viewModel.dateLoad
            }
        }
        viewModel.loadImageStart = { [weak self] in
            self?.activityIndicator.startAnimating()
        }
        viewModel.dataDidLoad = { [weak self] viewModel in
            guard let self = self else { return }
            let frame = CalculatorSize.calculateFramePhoto(width: viewModel.width,
                                                           height: viewModel.height,
                                                           heightNavBar: Int(self.navigationController?.navigationBar.frame.height ?? 0))
            self.imageView.frame = frame
            self.photographerLabel.text = viewModel.photographer
            self.dateLoadLabel.text = viewModel.dateLoad
            self.descriptionLabel.text = viewModel.description
        }
    }
}

extension PicturesDetailViewController {
    struct CalculatorSize {
        static func calculateFramePhoto(width: Int, height: Int, heightNavBar: Int) -> CGRect {
            let widthScreen = UIScreen.main.bounds.width
            let ratio = CGFloat(height) / CGFloat(width)
            let y = CGFloat(heightNavBar) + getStatusBarHeight()
            return CGRect(origin: CGPoint(x: 0,
                                          y: y),
                          size: CGSize(width: widthScreen, height: widthScreen * ratio))
        }
        
        private static func getStatusBarHeight() -> CGFloat {
                var statusBarHeight: CGFloat = 0
                if #available(iOS 15.0, *) {
                    let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
                    statusBarHeight = windowScene?.statusBarManager?.statusBarFrame.height ?? 0
                } else {
                    statusBarHeight = UIApplication.shared.statusBarFrame.height
                }
                return statusBarHeight
            }
    }
}
