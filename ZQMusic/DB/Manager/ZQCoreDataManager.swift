//
//  ZQCoreDataManager.swift
//  ZQMusic
//
//  Created by wp on 2023/10/8.
//

import Foundation
import CoreData

class ZQCoreDataManager {
    static var shared = ZQCoreDataManager()
    init() {
    }
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "zqmusic")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as? NSError {
                Logger.debug(.DB, message: "Unresolved：\(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                Logger.debug(.DB, message: "Unresolved：\(nserror), \(nserror.userInfo)")
            }
        }
    }

    func addFavorite(_ model:ItemModel)
    {
        let context = self.persistentContainer.viewContext
        let favoriteModel = NSEntityDescription.insertNewObject(forEntityName: "Favorite",
                                                       into: context) as! Favorite

        favoriteModel.isFavorite = true
        if let artistId = model.artistId {
            favoriteModel.artistId = NSNumber(value: artistId)
        }
        let modelId = "\(model.trackId ?? 0)\(model.trackName ?? "")\(model.artistViewUrl ?? "")".md5
        favoriteModel.modelId = modelId
        favoriteModel.artistName = model.artistName
        favoriteModel.artistViewUrl = model.artistViewUrl
        favoriteModel.artworkUrl100 = model.artworkUrl100
        favoriteModel.artworkUrl30 = model.artworkUrl30
        favoriteModel.artworkUrl60 = model.artworkUrl60
        if let collectionArtistId = model.collectionArtistId {
            favoriteModel.collectionArtistId = NSNumber(value: collectionArtistId)
        }
        favoriteModel.collectionArtistViewUrl = model.collectionArtistViewUrl
        favoriteModel.collectionCensoredName = model.collectionCensoredName
        favoriteModel.collectionExplicitness = model.collectionExplicitness
        if let collectionId = model.collectionId {
            favoriteModel.collectionId = NSNumber(value: collectionId)
        }
        favoriteModel.collectionName = model.collectionName
        if let collectionPrice = model.collectionPrice {
            favoriteModel.collectionPrice = NSNumber(value: collectionPrice)
        }
        favoriteModel.collectionViewUrl = model.collectionViewUrl
        favoriteModel.contentAdvisoryRating = model.contentAdvisoryRating
        favoriteModel.country = model.country
        favoriteModel.currency = model.currency
        favoriteModel.kind = model.kind
        favoriteModel.longDescription = model.longDescription
        favoriteModel.previewUrl = model.previewUrl
        favoriteModel.primaryGenreName = model.primaryGenreName
        if let trackId = model.trackId {
            favoriteModel.trackId = NSNumber(value: trackId)
        }
        favoriteModel.trackViewUrl = model.trackViewUrl
        favoriteModel.trackName = model.trackName
        favoriteModel.isFavorite = true
        do {
            try context.save()
        } catch {
            Logger.debug(.DB, message: "保存数据失败：\(error)")
        }
    }
    
    func getFavoriteStatus(_ model:ItemModel, completion:@escaping((_ isFavorite:Bool)->Void))
    {
        let modelId = "\(model.trackId ?? 0)\(model.trackName ?? "")\(model.artistViewUrl ?? "")".md5
        let context = self.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Favorite>(entityName:"Favorite")
        fetchRequest.fetchLimit = 1 //限定查询结果的数量
        fetchRequest.fetchOffset = 0 //查询的偏移量
        let predicate = NSPredicate(format: "modelId = '\(modelId)' ", "")
        fetchRequest.predicate = predicate
        do {
            let fetchedObjects = try context.fetch(fetchRequest)
            //遍历查询的结果
            if let result = fetchedObjects.first {
                let isFavorite = result.isFavorite
                DispatchQueue.main.async {
                    completion(isFavorite)
                }
            }else{
                DispatchQueue.main.async {
                    completion(false)
                }
            }
        }
        catch {
            Logger.debug(.DB, message: "更新数据失败：\(error)")
        }
    }
    
    func updateFavorite(_ model:ItemModel, isFavorite:Bool)
    {
        let modelId = "\(model.trackId ?? 1)\(model.trackName ?? "abc")\(model.artistViewUrl ?? "123")".md5
        let context = self.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Favorite>(entityName:"Favorite")
        fetchRequest.fetchLimit = 10000
        fetchRequest.fetchOffset = 0
        let predicate = NSPredicate(format: "modelId = '\(modelId)' ", "")
        fetchRequest.predicate = predicate
        do {
            let fetchedObjects = try context.fetch(fetchRequest)
            if fetchedObjects.isEmpty, isFavorite {
                self.addFavorite(model)
            }else{
                for favoriteModel in fetchedObjects{
                    favoriteModel.isFavorite = isFavorite
                }
                try context.save()
            }
        }
        catch {
            Logger.debug(.DB, message: "更新数据失败：\(error)")
        }
    }
    
    func getAllFavorite(completion:((_ array:[ItemModel])->Void))
    {
        let context = self.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Favorite>(entityName:"Favorite")
        fetchRequest.fetchLimit = 2000
        fetchRequest.fetchOffset = 0
        let predicate = NSPredicate(format: "isFavorite= '1' ", "")
        fetchRequest.predicate = predicate
        do {
            let fetchedObjects = try context.fetch(fetchRequest)
            let result:[ItemModel] = fetchedObjects.map { favoriteModel in
                var model = ItemModel.init()
                model.artistId = favoriteModel.artistId?.int64Value
                model.artistName = favoriteModel.artistName
                model.artistViewUrl = favoriteModel.artistViewUrl
                model.artworkUrl100 = favoriteModel.artworkUrl100
                model.artworkUrl30 = favoriteModel.artworkUrl30
                model.artworkUrl60 = favoriteModel.artworkUrl60
                model.collectionArtistId = favoriteModel.collectionArtistId?.intValue
                model.collectionArtistViewUrl = favoriteModel.collectionArtistViewUrl
                model.collectionCensoredName = favoriteModel.collectionCensoredName
                model.collectionExplicitness = favoriteModel.collectionExplicitness
                model.collectionId = favoriteModel.collectionId?.int64Value
                model.collectionName = favoriteModel.collectionName
                model.collectionPrice = favoriteModel.collectionPrice?.floatValue
                model.collectionViewUrl = favoriteModel.collectionViewUrl
                model.contentAdvisoryRating = favoriteModel.contentAdvisoryRating
                model.country = favoriteModel.country
                model.currency = favoriteModel.currency
                model.kind = favoriteModel.kind
                model.longDescription = favoriteModel.longDescription
                model.previewUrl = favoriteModel.previewUrl
                model.primaryGenreName = favoriteModel.primaryGenreName
                model.trackId = favoriteModel.trackId?.int64Value
                model.trackName = favoriteModel.trackName
                model.trackViewUrl = favoriteModel.trackViewUrl
                return model
            }
            completion(result)
        }
        catch {
            completion([])
            Logger.debug(.DB, message: "获取数据失败：\(error)")
        }
    }
}
