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
        if isConnectInternet {
            page += 1
            fetchPhotos()
        }
    }
    
    func getItem(by index: Int) -> PicturesListCellViewModelType {
        guard photos.count >= index else { return PicturesListCellModel(photographer: "", description: nil) }
        let photo = photos[index]
        let localViewModel = PicturesListCellModel(photographer: photo.photographer,
                                                       description: photo.description)
        localViewModel.startLoadImage = { [weak self] viewModel in
            self?.downloadImage(viewModel: viewModel, urlString: photo.urlPhoto)
        }
        return localViewModel
    }
    
    func getDetailItem(by index: Int) -> Photo {
        return photos[index]
    }
    
    var dataDidLoad: (() -> Void)?
    
    var showError: ((String) -> Void)?
    
    func refreshData() {
        photos = []
        page = 0
        isConnectInternet = true
        fetchData()
    }
    
    //MARK: - private property
    private var page: Int = 0
    private var perPage: Int = 50 // in API max: 80 default: 15
    
    private var photos: [Photo] = []
    private var networkManager: Networking
    private var dataStorageManager: DataStorage
    private var isConnectInternet: Bool = true
    
    init(networkManager: Networking = NetworkManager(), dataStorageManager: DataStorage = DataStorageManager()) {
        self.networkManager = networkManager
        self.dataStorageManager = dataStorageManager
    }
    
    private func fetchPhotos() {
        var params: [String: String] = [:]
        params.updateValue("\(page)", forKey: "page")
        params.updateValue("\(perPage)", forKey: "per_page")
        networkManager.request(parametrs: params) { [weak self] data, error in
            guard let self = self else { return }
            guard error == nil else {
                if let urlError = error as? URLError,
                   (urlError.code == URLError.notConnectedToInternet ||
                    urlError.code == URLError.timedOut){
                    self.isConnectInternet = false
                    self.showError?(error!.localizedDescription)
                    self.dataStorageManager.getAllData { [weak self] photos in
                        if !photos.isEmpty {
                            self?.photos = photos
                            self?.dataDidLoad?()
                        } else {
                            self?.showError?("No photos saved")
                        }
                    }
                } else {
                    self.showError?(error!.localizedDescription)
                }
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
    
    private func downloadImage(viewModel: PicturesListCellViewModelType, urlString: String) {
        networkManager.downloadPhoto(urlPhoto: urlString) { [weak self] data in
            self?.saveImage(urlPhoto: urlString, dataImage: data)
            viewModel.loadImage?(data)
        }
    }
    
    private func saveImage(urlPhoto: String, dataImage: Data?) {
        let index = photos.firstIndex { photo in
            photo.urlPhoto == urlPhoto
        }
        guard let index = index else { return }
        var photo = photos[index]
        let date = Date()
        photo.image = dataImage
        if photo.uploadDate == nil {
            photo.uploadDate = date
        }
        photos[index] = photo
        dataStorageManager.saveData(photo)
    }
}
