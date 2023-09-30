//
//  Service+Config.swift
//  FZChat
//
//  Created by wp on 2023/1/15.
//

import Foundation
import Moya

extension Service {
    enum Home {
        case search(keyword: String, country: String = DeviceInfo.countryCode, language: String = DeviceInfo.languageCode, limit: Int = 20)
    }
}

extension Service.Home: FZTargetType {
    //https://itunes.apple.com/search?term=jack+johnson&limit=100&offset=300
    var baseURL: URL {
        return URL.init(string: "https://itunes.apple.com")!
    }
    
    var parameters: [String: Any] {
        switch self {
        case .search(let keyword, let country, let language, let limit):
            return [
                "term":keyword,
                "country":country,
                "language":language,
                "limit":limit,
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
        case .search(_,_,_,_):
            return .requestParameters(parameters: self.parameters, encoding: URLEncoding.queryString)
        }
    }
}
