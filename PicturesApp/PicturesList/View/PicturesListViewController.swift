//
//  PicturesListViewController.swift
//  PicturesApp
//
//  Created by Антон Кочетков on 14.03.2022.
//

import UIKit

protocol PicturesListViewModelType {
    var count: Int { get }
    func getItem(by index: Int) -> PicturesListCellViewModelType
    func fetchData()
    func getDetailItem(by index: Int) -> Photo
    var dataDidLoad: (() -> Void)? { get set }
    var showError: ((String) -> Void)? { get set }
}

class PicturesListViewController: UIViewController {

    var viewModel: PicturesListViewModelType!
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collView.register(PicturesListCollectionViewCell.self,
                          forCellWithReuseIdentifier: PicturesListCollectionViewCell.identifier)
        return collView
    }()
    
    private let itemsPerRow: CGFloat = 2
    private let sectionInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Photos"
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        updateView()
        viewModel.fetchData()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        collectionView.frame = view.bounds
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView.contentOffset.y > scrollView.contentSize.height / 1.30 {
            viewModel.fetchData()
        }
    }
    
    func updateView() {
        viewModel.dataDidLoad = {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
        viewModel.showError = { message in
            DispatchQueue.main.async {
                self.showError(message: message)
            }
        }
    }
}

extension PicturesListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PicturesListCollectionViewCell.identifier, for: indexPath) as! PicturesListCollectionViewCell
        cell.set(viewModel: viewModel.getItem(by: indexPath.row))
        return cell
    }
}

extension PicturesListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem * 1.35)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}

extension PicturesListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailPhoto = viewModel.getDetailItem(by: indexPath.row)
        let detailVC = AppAssembly.assemblyDetail(detailPhoto)
        
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
