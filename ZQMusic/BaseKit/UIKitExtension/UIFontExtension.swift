//
//  UIFontExtension.swift
//  KLChat
//
//  Created by lw on 2022/3/15.
//

import Foundation
import UIKit


fileprivate extension UIFont.Weight {
    var name:String {
        get {
            switch self {
            case .ultraLight:
                return "UltraLight"
            case .thin:
                return "Thin"
            case .light:
                return "Light"
            case .regular:
                return "Regular"
            case .medium:
                return "Medium"
            case .semibold:
                return "Semibold"
            case .bold:
                return "Bold"
            case .heavy:
                return "Heavy"
            case .black:
                return "Black"
            default:
                return ""
            }
        }
    }
}

extension UIFont {
    
    /// <#Description#>
    enum FontName {
        ///平方-简
        case PingFangSC
    }
    
    static func font(_ name:FontName = .PingFangSC, size:CGFloat, weight: UIFont.Weight) -> UIFont {
        
        switch name {
        case .PingFangSC:
            let name = "PingFangSC-\(weight.name)"
            guard let font = UIFont.init(name: name, size: size) else {
                return UIFont.systemFont(ofSize: size, weight: weight)
            }
            return font
        }
    }
}
