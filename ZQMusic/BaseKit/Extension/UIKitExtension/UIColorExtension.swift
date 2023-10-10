//
//  UIColorExtension.swift
//  KLChat
//
//  Created by lw on 2022/3/15.
//

import UIKit

extension UIColor {
    
    public convenience init(_ hexString: String) {
        self.init(hexString: hexString, alpha: 1.0)
    }
    
    public convenience init(hexInt: Int, alpha: Float = 1.0) {
        let hexString = String(format: "%06X", hexInt)
        self.init(hexString: hexString, alpha: alpha)
    }
        
    public convenience init(hexString: String, alpha: Float = 1.0) {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var mAlpha: CGFloat = CGFloat(alpha)
        var minusLength = 0
        
        var scanner = Scanner(string: hexString)
        
        if hexString.hasPrefix("#") {
            if #available(iOS 13.0, *) {
                scanner.currentIndex = scanner.string.index(scanner.string.startIndex, offsetBy: "#".count)
            } else {
                // Fallback on earlier versions
                
            }
            minusLength = 1
        }
        if hexString.hasPrefix("0x") {
            if #available(iOS 13.0, *) {
                scanner.currentIndex = scanner.string.index(scanner.string.startIndex, offsetBy: "0x".count)
            } else {
                // Fallback on earlier versions
            }
            minusLength = 2
        }
        var hexValue: UInt64 = 0
        scanner.scanHexInt64(&hexValue)
        switch hexString.count - minusLength {
        case 3:
            red = CGFloat((hexValue & 0xF00) >> 8) / 15.0
            green = CGFloat((hexValue & 0x0F0) >> 4) / 15.0
            blue = CGFloat(hexValue & 0x00F) / 15.0
        case 4:
            red = CGFloat((hexValue & 0xF000) >> 12) / 15.0
            green = CGFloat((hexValue & 0x0F00) >> 8) / 15.0
            blue = CGFloat((hexValue & 0x00F0) >> 4) / 15.0
            mAlpha = CGFloat(hexValue & 0x000F) / 15.0
        case 6:
            red = CGFloat((hexValue & 0xFF0000) >> 16) / 255.0
            green = CGFloat((hexValue & 0x00FF00) >> 8) / 255.0
            blue = CGFloat(hexValue & 0x0000FF) / 255.0
        case 8:
            red = CGFloat((hexValue & 0xFF000000) >> 24) / 255.0
            green = CGFloat((hexValue & 0x00FF0000) >> 16) / 255.0
            blue = CGFloat((hexValue & 0x0000FF00) >> 8) / 255.0
            mAlpha = CGFloat(hexValue & 0x000000FF) / 255.0
        default:
            break
        }
        self.init(red: red, green: green, blue: blue, alpha: mAlpha)
    }
        
    /// color components value between 0 to 255
    public convenience init(byRed red: Int, green: Int, blue: Int, alpha: Float = 1.0) {
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: CGFloat(alpha))
    }
    
    public static func rgb(_ red:Int, _ green: Int, _ blue:Int) -> UIColor {
        return UIColor.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    public static func rgba(_ red:Int, _ green: Int, _ blue:Int, _ alpha:Float) -> UIColor {
        return UIColor.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: CGFloat(alpha))
    }
    
    public func components() -> (red:CGFloat, green:CGFloat, blue:CGFloat , alpha:CGFloat) {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        #if os(macOS)
            self.usingColorSpace(.genericRGB)!.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        #else
            self.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        #endif
        return (red, green, blue, alpha)
    }
    
    //返回随机颜色
    public class var randomColor: UIColor {
        get
        {
            let red = CGFloat(arc4random()%256)/255.0
            let green = CGFloat(arc4random()%256)/255.0
            let blue = CGFloat(arc4random()%256)/255.0
            return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
        }
    }
    
    func isEqualTo(color:UIColor) -> Bool {
        
        let coms  = self.components()
        let otherComs = color.components()
        if coms.red == otherComs.red && coms.green == otherComs.green && coms.blue == otherComs.blue && coms.alpha == otherComs.alpha {
            return true
        }
        return false
    }
}

struct Koala<KL> {
    let kl: KL
    init(_ kl: KL) {
        self.kl = kl
    }
}

protocol Koalable {
    associatedtype Element
    var kl: Koala<Element> { get }
    static var kl: Koala<Element>.Type { get }
}

extension Koalable {
    var kl: Koala<Self> { Koala(self) }
    static var kl: Koala<Self>.Type { Koala<Self>.self }
}
extension UIColor: Koalable { }
extension Koala where KL == UIColor {
    static var defaultBackgroundColor:UIColor {
        return UIColor.init(hexString: "#191933")
    }
}
