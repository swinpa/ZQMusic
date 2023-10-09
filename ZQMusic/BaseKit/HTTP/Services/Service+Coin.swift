//
//  Service+Config.swift
//  ZQMusic
//
//  Created by wp on 9/29/23.
//

import Foundation
import Moya

extension Service {
    enum Home {
        case search(keyword: String, entity:String, country: String = DeviceInfo.countryCode, language: String = DeviceInfo.languageCode, offset:Int = 0, limit: Int = 20)
    }
}

extension Service.Home: ZQMTargetType {
    //https://itunes.apple.com/search?term=jack+johnson&limit=100&offset=300
    var baseURL: URL {
        return URL.init(string: "https://itunes.apple.com")!
    }
    
    var parameters: [String: Any] {
        switch self {
        case .search(let keyword, let entity, let country, let language, let offset, let limit):
            return [
                "term":keyword,
                "media":"music",
                "entity":entity,
                "country":country,
                "language":language,
                "limit":limit,
                "offset":offset,
            ]
        }
    }
    public var path: String {
        switch self {
        case .search:
            return "/search"
        }
    }
    public var method: Moya.Method {
        switch self {
        default:
            return .get
        }
    }
    public var headers: [String : String]? {
        switch self {
        default:
            return [:]
        }
    }
    public var task: Task {
        switch self {
        case .search(_,_,_,_,_,_):
            return .requestParameters(parameters: self.parameters, encoding: URLEncoding.queryString)
        }
    }
}
