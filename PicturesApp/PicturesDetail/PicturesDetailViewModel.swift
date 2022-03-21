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
        loadImageStart?()
        height = photo.height
        width = photo.width
        photographer = "By \(photo.photographer)"
        dateLoad = "Upload date: - "
        description = photo.alt.isEmpty ? nil : "Description: \(photo.alt)"
        dataDidLoad?(self)
        downloadPhoto()
    }
    
    private func downloadPhoto() {
        guard let url = URL(string: photo.size.large) else { return }
        networkManager.downloadPhoto(url: url) { [weak self] data in
            let date = Date()
            self?.dateLoad = "Upload date: \(self?.dateFormatter.string(from: date) ?? "")"
            self?.loadImage?(data)
        }
    }
}
