//
//  PicturesListCellViewModel.swift
//  PicturesApp
//
//  Created by Антон Кочетков on 21.03.2022.
//

import Foundation

class PicturesListCellViewModel: PicturesListCellViewModelType {
    var photographer: String = ""
    var description: String?
    var loadImage: ((Data?) -> Void)?
    var startLoadImage: (() -> Void)?
    
    private var url: String?
    private var networkManager: Networking
    
    init(networkManager: Networking) {
        self.networkManager = networkManager
        self.startLoadImage = {
            self.downloadImage()
        }
    }
    
    func set(_ photo: Photo) {
        self.photographer = "by \(photo.photographer)"
        self.description = "description: \(photo.alt)"
        self.url = photo.size.large
    }
    
    private func downloadImage() {
        guard let urlPhoto = self.url,
              let url = URL(string: urlPhoto) else { return }
        networkManager.downloadPhoto(url: url) { data in
            self.loadImage?(data)
        }
    }
}
