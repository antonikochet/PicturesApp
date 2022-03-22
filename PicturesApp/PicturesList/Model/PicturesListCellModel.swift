//
//  PicturesListCellViewModel.swift
//  PicturesApp
//
//  Created by Антон Кочетков on 21.03.2022.
//

import Foundation

class PicturesListCellModel: PicturesListCellViewModelType {
    var photographer: String = ""
    var description: String?
    var loadImage: ((Data?) -> Void)?
    var startLoadImage: ((PicturesListCellViewModelType) -> Void)?
    
//    static var count: Int = 0
//    var index: Int
//
    init(photographer: String, description: String?) {
        self.photographer = photographer
        self.description = description
//        PicturesListCellModel.count += 1
//        index = PicturesListCellModel.count
//        print("init count: \(PicturesListCellModel.count) index: \(index)")
    }

//    deinit {
//        PicturesListCellModel.count -= 1
//        print("deinit count: \(PicturesListCellModel.count) index: \(index)")
//    }
}
