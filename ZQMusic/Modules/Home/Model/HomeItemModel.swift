//
//  Model.swift
//  ZQMusic
//
//  Created by wp on 9/29/23.
//

import Foundation


struct ItemModel:Codable{
    var artistId: Int64?
    var artistName: String?
    var artistViewUrl: String?
    var artworkUrl100: String?
    var artworkUrl30: String?
    var artworkUrl60: String?
    var collectionArtistId: Int?
    var collectionArtistViewUrl: String?
    var collectionCensoredName: String?
    var collectionExplicitness: String?
    var collectionHdPrice: Float?
    var collectionId: Int64?
    var collectionName: String?
    var collectionPrice: Float?
    var collectionViewUrl: String?
    var contentAdvisoryRating: String?
    var country: String?
    var currency: String?
    var hasITunesExtras: Bool?
    var kind: String?
    var longDescription: String?
    var previewUrl: String?
    var primaryGenreName: String?
    var releaseDate: String?
    var trackCensoredName: String?
    var trackCount: Int?
    var trackExplicitness: String?
    var trackHdPrice: Float?
    var trackHdRentalPrice: Float?
    var trackId: Int64?
    var trackName: String?
    var trackNumber: Int?
    var trackPrice: Float?
    var trackRentalPrice: Float?
    var trackTimeMillis: Int64?
    var trackViewUrl: String?
    var wrapperType: String?
}

struct HomeSearchResponseModel:Codable{
    let resultCount:Int
    let results:[ItemModel]
}
