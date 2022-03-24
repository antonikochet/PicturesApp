//
//  DataStorageManager.swift
//  PicturesApp
//
//  Created by Антон Кочетков on 21.03.2022.
//

import Foundation
import CoreData

protocol DataStorage {
    func saveData(_ data: Photo)
    func getAllData(completion: @escaping (([Photo])-> Void))
}

class DataStorageManager: DataStorage {
    // MARK: - Core Data stack

    private static let maxSavePicture: Int = 100
    private var countPicturesInBD: Int = 0 
    
    private var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "PicturesApp")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    private var viewContext: NSManagedObjectContext
    
    init() {
        viewContext = persistentContainer.newBackgroundContext()
        getCountPictures()
    }
    
    // MARK: - Core Data Saving support

    private func saveContext() {
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                let nserror = error as NSError
                print("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    private func getCountPictures() {
        do {
            countPicturesInBD = try viewContext.count(for: Picture.fetchRequest())
        } catch {
            let nserror = error as NSError
            print(nserror.userInfo)
        }
    }
    
    private func deleteLastData() {
        let fetchAddedDateRequest = Picture.fetchRequest()
        fetchAddedDateRequest.sortDescriptors = [NSSortDescriptor(key: "addedDate", ascending: true)]
        fetchAddedDateRequest.fetchLimit = 1
        guard let lastPicture = try? viewContext.fetch(fetchAddedDateRequest).first else { return }
        viewContext.delete(lastPicture)
        countPicturesInBD -= 1
    }
    // MARK: - Protocol
    
    func saveData(_ data: Photo) {
        viewContext.perform { [weak self] in
            guard let self = self else { return }
            let fetchRequest = Picture.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "serverId = %@", argumentArray: [data.id])
            guard let count = try? self.viewContext.count(for: fetchRequest), count == 0 else { return }
            if self.countPicturesInBD >= DataStorageManager.maxSavePicture {
                self.deleteLastData()
            }
            let picture = Picture(context: self.viewContext)
            picture.convertFrom(photo: data)
            self.saveContext()
            self.countPicturesInBD += 1
        }
    }
    
    func getAllData(completion: @escaping (([Photo])-> Void)) {
        viewContext.perform { [weak self] in
            guard let self = self else { return }
            let fetchRequest = Picture.fetchRequest()
            let sortDescriptor = NSSortDescriptor(key: "addedDate", ascending: true)
            fetchRequest.sortDescriptors = [sortDescriptor]
            guard let pictures = try? self.viewContext.fetch(fetchRequest) else { return }
            self.countPicturesInBD = pictures.count
            completion(pictures.map { $0.convertToPhoto() })
        }
    }
}
