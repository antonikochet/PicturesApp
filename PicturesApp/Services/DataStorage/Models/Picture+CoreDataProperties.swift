//
//  Picture+CoreDataProperties.swift
//  
//
//  Created by Антон Кочетков on 22.03.2022.
//
//

import Foundation
import CoreData


extension Picture {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Picture> {
        return NSFetchRequest<Picture>(entityName: "Picture")
    }

    @NSManaged public var descriptionPicture: String?
    @NSManaged public var height: Int16
    @NSManaged public var image: Data?
    @NSManaged public var photographer: String?
    @NSManaged public var serverId: Int64
    @NSManaged public var uploadDate: Date?
    @NSManaged public var url: String?
    @NSManaged public var widht: Int16
    @NSManaged public var addedDate: Date?

}
