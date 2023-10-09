//
//  Favorite+CoreDataProperties.swift
//  ZQMusic
//
//  Created by wp on 2023/10/8.
//

import Foundation
import CoreData


extension Favorite {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Favorite> {
        return NSFetchRequest<Favorite>(entityName: "Favorite")
    }
    
    @NSManaged public var modelId: String
    @NSManaged public var isFavorite: Bool
    @NSManaged public var artistId: NSNumber?
    @NSManaged public var artistName: String?
    @NSManaged public var artistViewUrl: String?
    @NSManaged public var artworkUrl100: String?
    @NSManaged public var artworkUrl30: String?
    @NSManaged public var artworkUrl60: String?
   
    @NSManaged public var collectionArtistId: NSNumber?
    
    @NSManaged public var collectionArtistViewUrl: String?
    @NSManaged public var collectionCensoredName: String?
    @NSManaged public var collectionExplicitness: String?
    
    @NSManaged public var collectionId: NSNumber?
    @NSManaged public var collectionName: String?
    @NSManaged public var collectionPrice: NSNumber?
    @NSManaged public var collectionViewUrl: String?
    
    @NSManaged public var contentAdvisoryRating: String?
    @NSManaged public var country: String?
    @NSManaged public var currency: String?
    @NSManaged public var kind: String?
    @NSManaged public var longDescription: String?
    @NSManaged public var previewUrl: String?
    
    @NSManaged public var primaryGenreName: String?
    @NSManaged public var trackId: NSNumber?
    @NSManaged public var trackName: String?
    @NSManaged public var trackViewUrl: String?

}
