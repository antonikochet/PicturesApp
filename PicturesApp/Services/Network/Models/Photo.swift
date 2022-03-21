//
//  Photo.swift
//  PicturesApp
//
//  Created by Антон Кочетков on 15.03.2022.
//

import Foundation

struct PhotosResponse: Decodable {
    let photos: [Photo]
    let page: Int?
    let perPage: Int?
    
    enum CodingKeys: String, CodingKey {
        case photos, page
        case perPage = "per_page"
    }
}

struct Photo: Decodable {
    let id: Int
    let size: PhotoSize
    let photographer: String
    let alt: String
    let width: Int
    let height: Int
    var uploadDate: Date?
    
    enum CodingKeys: String, CodingKey {
        case id, photographer, alt, width, height, uploadDate
        case size = "src"
    }
}

struct PhotoSize: Decodable {
    let large: String
}
