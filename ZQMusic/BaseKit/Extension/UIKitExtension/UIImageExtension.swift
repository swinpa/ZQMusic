//
//  UIImageExtension.swift
//  KLChat
//
//  Created by lw on 2022/3/16.
//

import UIKit

enum GradientDirection {
case ltr
case rtl
case ttb
case btt
}

extension UIImage {
    convenience init(color: UIColor, size: CGSize = .init(width: 1, height: 1)) {
        
        /*
         UIGraphicsBeginImageContextWithOptions(size, false, 0)
         color.setFill()
         UIRectFill(CGRect(origin: CGPoint.zero, size: size))
         let image = UIGraphicsGetImageFromCurrentImageContext()
         UIGraphicsEndImageContext()
         */
        if let result = UIGraphicsImageRenderer(size: size).image(actions: { context in
            color.setFill()
            context.fill(.init(origin: .zero, size: size))
        }).cgImage {
            self.init(cgImage: result)
        }else{
            self.init()
        }
    }
    
    func drawRectWithRoundedCorner(_ radius:CGFloat, _ size: CGSize) -> UIImage {
        let rect = CGRect.init(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, UIScreen.main.scale)
        guard let context = UIGraphicsGetCurrentContext() else { return self }
        
        let path = UIBezierPath.init(roundedRect: rect, byRoundingCorners: UIRectCorner.allCorners, cornerRadii: CGSize.init(width: radius, height: radius))
        
        context.addPath(path.cgPath)
        context.clip()
        
        self.draw(in: rect)
        
        context.drawPath(using: .fillStroke)
        
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else { return self }
        UIGraphicsEndImageContext()
        return image
        
    }
    
    /// 获取渐变色
    /// - Parameters:
    ///   - size: 尺寸
    ///   - colors: 渐变颜色
    ///   - gradientType: 方向类型
    static func gradientImage(size: CGSize, colors: [UIColor], direction: GradientDirection) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 1)
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        context.saveGState()
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        var cgColors: [CGColor] = []
        for color in colors {
            cgColors.append(color.cgColor)
        }
        guard  let gradientRef = CGGradient(colorsSpace: colorSpace, colors: cgColors as CFArray, locations: nil) else {
            return nil
        }
        var startPoint = CGPoint.zero
        var endPoint = CGPoint.zero
        switch direction {
        case .ltr:
            startPoint = CGPoint(x: 0, y: size.height/2.0)
            endPoint = CGPoint(x: size.width, y: size.height/2.0)
        case .rtl:
            startPoint = CGPoint(x: size.width, y: size.height/2.0)
            endPoint = CGPoint(x: 0, y: size.height/2.0)
        case .ttb:
            startPoint = CGPoint(x: size.width/2.0, y: 0.0)
            endPoint = CGPoint(x: size.width/2.0, y: size.height)
        case .btt:
            startPoint = CGPoint(x: size.width/2.0, y: size.height)
            endPoint = CGPoint(x: size.width/2.0, y: 0.0)
        }
        context.drawLinearGradient(gradientRef, start: startPoint, end: endPoint, options: CGGradientDrawingOptions(arrayLiteral: .drawsBeforeStartLocation, .drawsAfterEndLocation))
        let gradientImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return gradientImage
    }
}

