//
//  Model.swift
//  ZQMusic
//
//  Created by wp on 9/29/23.
//

import Foundation

/*
 artistName = "Chris Columbus";
 artworkUrl100 = "https://is1-ssl.mzstatic.com/image/thumb/Video126/v4/68/0a/36/680a3626-b96c-4d04-0bd6-859ecf79299b/pr_source.jpg/100x100bb.jpg";
 artworkUrl30 = "https://is1-ssl.mzstatic.com/image/thumb/Video126/v4/68/0a/36/680a3626-b96c-4d04-0bd6-859ecf79299b/pr_source.jpg/30x30bb.jpg";
 artworkUrl60 = "https://is1-ssl.mzstatic.com/image/thumb/Video126/v4/68/0a/36/680a3626-b96c-4d04-0bd6-859ecf79299b/pr_source.jpg/60x60bb.jpg";
 collectionArtistId = 199257486;
 collectionArtistViewUrl = "https://itunes.apple.com/us/artist/warner-bros-entertainment-inc/199257486?uo=4";
 collectionCensoredName = "Harry Potter Complete Collection";
 collectionExplicitness = notExplicit;
 collectionHdPrice = "14.99";
 collectionId = 1636409066;
 collectionName = "Harry Potter 8-Film + Return to Hogwarts";
 collectionPrice = "14.99";
 collectionViewUrl = "https://itunes.apple.com/us/movie/harry-potter-and-the-sorcerers-stone/id271469503?uo=4";
 contentAdvisoryRating = PG;
 country = USA;
 currency = USD;
 hasITunesExtras = 1;
 kind = "feature-movie";
 longDescription = "In this enchanting film adaptation of J.K. Rowling's delightful bestseller, Harry Potter learns on his 11th birthday that he is the orphaned first son of two powerful wizards and possesses magical powers of his own. At Hogwarts School of Witchcraft and Wizardry, Harry embarks on the adventure of a lifetime. He learns the high-flying sport Quidditch and plays a thrilling game with living chess pieces on his way to face a Dark Wizard bent on destroying him. For the most extraordinary adventure, see you on platform nine and three quarters!";
 previewUrl = "https://video-ssl.itunes.apple.com/itunes-assets/Video128/v4/df/0a/41/df0a418e-befa-2514-fcb8-a7af5295d99f/mzvf_5014275573236309395.640x480.h264lc.U.p.m4v";
 primaryGenreName = "Kids & Family";
 releaseDate = "2001-11-16T08:00:00Z";
 trackCensoredName = "Harry Potter and the Sorcerer's Stone";
 trackCount = 9;
 trackExplicitness = notExplicit;
 trackHdPrice = "14.99";
 trackHdRentalPrice = "3.99";
 trackId = 271469503;
 trackName = "Harry Potter and the Sorcerer's Stone";
 trackNumber = 1;
 trackPrice = "14.99";
 trackRentalPrice = "3.99";
 trackTimeMillis = 9141663;
 trackViewUrl = "https://itunes.apple.com/us/movie/harry-potter-and-the-sorcerers-stone/id271469503?uo=4";
 wrapperType = track;
 */
struct ItemModel:Codable{
    var artistName: String
    var artworkUrl100: String
    var artworkUrl30: String
    var artworkUrl60: String
   
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
    var longDescription: String
    var previewUrl: String?
    var primaryGenreName: String?
    var releaseDate: String?
    var trackCensoredName: String?
    var trackCount: Int?
    var trackExplicitness: String?
    var trackHdPrice: Float?
    var trackHdRentalPrice: Float?
    var trackId: Int64
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
