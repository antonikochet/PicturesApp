//
//  PicturesListViewModel.swift
//  PicturesApp
//
//  Created by Антон Кочетков on 14.03.2022.
//

import Foundation

class PicturesListViewModel: PicturesListViewModelType {
    //MARK: - viewModelType property and methods
    var count: Int {
        return photos.count
    }
    
    func fetchData() {
        page += 1
        fetchPhotos()
    }
    
    func getItem(by index: Int, viewModel: PicturesListCellViewModelType?) -> PicturesListCellViewModelType {
        let photo = photos[index]
        if let viewModel = viewModel as? PicturesListCellViewModel {
            viewModel.set(photo)
            return viewModel
        } else {
            let viewModel = PicturesListCellViewModel(networkManager: networkManager)
            viewModel.set(photo)
            return viewModel
        }
    }
    
    func getDetailItem(by index: Int) -> Photo {
        return photos[index]
    }
    
    var dataDidLoad: (() -> Void)?
    
    var showError: ((String) -> Void)?
    
    //MARK: - private property
    private var page: Int = 0
    private var perPage: Int = 50 // in API max: 80 default: 15
    
    private var photos: [Photo] = []
    private var networkManager: Networking
    
    init(networkManager: Networking = NetworkManager()) {
        self.networkManager = networkManager
    }
    
    private func fetchPhotos() {
        var params: [String: String] = [:]
        params.updateValue("\(page)", forKey: "page")
        params.updateValue("\(perPage)", forKey: "per_page")
        networkManager.request(parametrs: params) { [weak self] data, error in
            guard let self = self else { return }
            guard error == nil else {
                self.showError?(error!.localizedDescription)
                return
            }
            if let data = data {
                if let response = try? JSONDecoder().decode(PhotosResponse.self, from: data) {
                    self.photos.append(contentsOf: response.photos)
                    self.dataDidLoad?()
                }
            }
        }
    }
    
    private func formatterPhotoToViewModel(_ photo: Photo) -> PicturesListCellViewModelType {
        let vm = PicturesListCellViewModel(networkManager: networkManager)
        vm.set(photo)
        return vm
    }
    
    private func downloadImage(viewModel: PicturesListCellViewModelType, urlString: String) {
        guard let url = URL(string: urlString) else { return }
        networkManager.downloadPhoto(url: url) { data in
            viewModel.loadImage?(data)
        }
    }
}
