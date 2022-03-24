//
//  PicturesDetailViewModel.swift
//  PicturesApp
//
//  Created by Антон Кочетков on 20.03.2022.
//

import Foundation

class PicturesDetailViewModel: PicturesDetailViewModelType {
   
    //MARK: - view model property
    var loadImage: ((Data?) -> Void)?
    var loadImageStart: (() -> Void)?
    var dataDidLoad: ((PicturesDetailViewModelType) -> Void)?
    func showData() {
        formatterViewModel()
    }
    
    var width: Int = 0
    var height: Int = 0
    var photographer: String = ""
    var dateLoad: String = ""
    var description: String? = ""
    var image: Data?
    
    //MARK: - private property
    private var photo: Photo
    
    private var networkManager: Networking
    
    private var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .medium
        dateFormatter.timeZone = .current
        return dateFormatter
    }()
    
    init(_ photo: Photo, networkManager: Networking = NetworkManager()) {
        self.photo = photo
        self.networkManager = networkManager
    }
    
    private func formatterViewModel() {
        height = photo.height
        width = photo.width
        photographer = "By \(photo.photographer)"
        description = photo.description.isEmpty ? nil : "Description: \(photo.description)"
        if let image = photo.image,
           let date = photo.uploadDate {
            dateLoad = "Upload date: \(dateFormatter.string(from: date))"
            loadImage?(image)
        } else {
            loadImageStart?()
            dateLoad = "Upload date: - "
            downloadPhoto()
        }
        dataDidLoad?(self)
    }
    
    private func downloadPhoto() {
        networkManager.downloadPhoto(urlPhoto: photo.urlPhoto) { [weak self] data in
            let date = Date()
            self?.dateLoad = "Upload date: \(self?.dateFormatter.string(from: date) ?? "")"
            self?.loadImage?(data)
        }
    }
}
