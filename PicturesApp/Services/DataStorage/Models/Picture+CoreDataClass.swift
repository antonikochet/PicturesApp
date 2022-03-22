//
//  Picture+CoreDataClass.swift
//  
//
//  Created by Антон Кочетков on 21.03.2022.
//
//

import Foundation
import CoreData


public class Picture: NSManagedObject {

}

extension Picture {
    func convertFrom(photo: Photo) {
        photographer = photo.photographer
        serverId = Int64(photo.id)
        descriptionPicture = photo.description
        url = photo.urlPhoto
        widht = Int16(photo.width)
        height = Int16(photo.height)
        uploadDate = photo.uploadDate
        image = photo.image
        addedDate = Date()
    }
    
    func convertToPhoto() -> Photo {
        Photo(id: Int(serverId),
              size: PhotoSize(large: url ?? ""),
              photographer: photographer ?? "",
              description: descriptionPicture ?? "",
              width: Int(widht),
              height: Int(height),
              uploadDate: uploadDate,
              image: image)
    }
}
