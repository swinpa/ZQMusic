//
//  StringExtension.swift
//  KLChat
//
//  Created by lw on 2022/3/23.
//

import Foundation
import CommonCrypto
import CryptoKit

extension String {
    
    public var md5: String {
        let computed = Insecure.MD5.hash(data: self.data(using: .utf8)!)
        return computed.map { String(format: "%02hhx", $0) }.joined()
    }
    
    /// 计算宽度和高度（核心)
    func size(width: CGFloat, height: CGFloat) -> CGSize {
        let defaultOptions: NSStringDrawingOptions = [.usesLineFragmentOrigin, .usesFontLeading]
        let maxSize = CGSize(width: width, height: height)
        let rect = self.boundingRect(with: maxSize, options: defaultOptions, context: nil)
        let textWidth: CGFloat = CGFloat(Int(rect.width) + 1)
        let textHeight: CGFloat = CGFloat(Int(rect.height) + 1)
        return CGSize(width: textWidth, height: textHeight)
    }
    
    func boundingRect(with constrainedSize: CGSize, font: UIFont, lineSpacing: CGFloat? = nil) -> CGSize {
         let attritube = NSMutableAttributedString(string: self)
         let range = NSRange(location: 0, length: attritube.length)
     attritube.addAttributes([NSAttributedString.Key.font: font], range: range)
         if lineSpacing != nil {
             let paragraphStyle = NSMutableParagraphStyle()
             paragraphStyle.lineSpacing = lineSpacing!
             attritube.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: range)
         }
         
         let rect = attritube.boundingRect(with: constrainedSize, options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil)
         var size = rect.size
         
         if let currentLineSpacing = lineSpacing {
             // 文本的高度减去字体高度小于等于行间距，判断为当前只有1行
             let spacing = size.height - font.lineHeight
             if spacing <= currentLineSpacing && spacing > 0 {
                 size = CGSize(width: size.width, height: font.lineHeight)
             }
         }
         
         return size
     }
     
     func boundingRect(with constrainedSize: CGSize, font: UIFont, lineSpacing: CGFloat? = nil, lines: Int) -> CGSize {
         if lines < 0 {
             return .zero
         }
         
         let size = boundingRect(with: constrainedSize, font: font, lineSpacing: lineSpacing)
         if lines == 0 {
             return size
         }

         let currentLineSpacing = (lineSpacing == nil) ? (font.lineHeight - font.pointSize) : lineSpacing!
         let maximumHeight = font.lineHeight*CGFloat(lines) + currentLineSpacing*CGFloat(lines - 1)
         if size.height >= maximumHeight {
             return CGSize(width: size.width, height: maximumHeight)
         }
         
         return size
     }
     
     static func attributedString(withImage img:UIImage,imgSpace:Float = 8, text:String, font:UIFont, color:UIColor) ->NSMutableAttributedString {
         let attachment = NSTextAttachment.init()
         attachment.image = img
         attachment.bounds = CGRect.init(x: 0, y: -5, width: img.size.width, height: img.size.height)
         
         let attributedString = NSMutableAttributedString.init(string: "", attributes: [
            NSAttributedString.Key.font : font,
            NSAttributedString.Key.foregroundColor : color
         ])
         let string = NSMutableAttributedString.init(string: text, attributes: [
            NSAttributedString.Key.font : font,
            NSAttributedString.Key.foregroundColor : color
         ])
         
         let attr: [NSAttributedString.Key : Any] = [.font: font,.foregroundColor: color]
         string.addAttributes(attr, range: NSRange(location: 0, length: string.length))
         
         let imgString = NSAttributedString.init(attachment: attachment)
         attributedString.append(imgString)
         attributedString.append(NSAttributedString.init(string: " "))
//         attributedString.addAttribute(NSAttributedString.Key.kern, value: NSNumber.init(value: imgSpace), range: NSRange.init(location: 1, length: 1))
         attributedString.append(string)
         
         return attributedString
     }

    func subString(with range: NSRange) -> String {
        let text = self as NSString
        let subStr = text.substring(with: range) as String
        return subStr
    }
    func range(of string: String) -> NSRange {
        let text = self as NSString
        return text.range(of: string)
    }
    
    func lastRange(of string: String) -> NSRange? {
        let text = self as NSString
        var result:NSRange?
        var range = NSRange.init(location: 0, length: self.count)
        while text.range(of: string, range: range).location != NSNotFound {
            let r = text.range(of: string, range: range)
            range = NSRange.init(location: r.location+r.length, length: self.count - r.location - r.length)
            result = NSRange.init(location: r.location, length: r.length)
        }
        return result
    }

    var localizedValue: String {
        return NSLocalizedString(self, comment: "")
    }
    
    func findKeyForLocalizedString() -> String? {
        guard let preferredLanguage = Locale.preferredLanguages.first else {
            return nil
        }
        let mainBundle = Bundle.main
        guard let lprojPath = Bundle.main.path(forResource: preferredLanguage, ofType: "lproj") else {
            return nil
        }
        let filePath = "\(lprojPath)/Localizable.strings"
        guard let dict = NSDictionary(contentsOfFile: filePath) as? [String: String] else {
            return nil
        }
        let key = dict.filter { (key: String, value: String) in
            return value == self
        }.first?.key
        return key
    }
    
}
