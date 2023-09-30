//
//  DeviceInfo.swift
//  ZQMusic
//
//  Created by wp on 9/30/23.
//

import Foundation

enum DeviceInfo {
    
    static var countryCode: String {
        let currentLocale = Locale.autoupdatingCurrent
        var countryCode:String?
        if #available(iOS 16.0, *) {
            countryCode = currentLocale.language.region?.identifier
        }else{
            countryCode = currentLocale.regionCode
        }
        let country = countryCode ?? "US"
        return country
    }
    
    static var languageCode: String {
        guard var lang = Locale.preferredLanguages.first else {
            return "en_us"
        }
        return lang
    }
}
