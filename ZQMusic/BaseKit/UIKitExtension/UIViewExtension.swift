//
//  UIViewExtension.swift
//  KLChat
//
//  Created by lw on 2022/3/15.
//

import Foundation
import UIKit
import MBProgressHUD
import CoreImage

extension UIView {
    
    // MARK: - 常用位置属性
    var left:CGFloat {
        get {
            return self.frame.x
        }
        set(newLeft) {
            self.frame.x = newLeft
        }
    }
    var x:CGFloat {
        get {
            return self.frame.x
        }
        set(newX) {
            self.frame.x = newX
        }
    }
    var top:CGFloat {
        get {
            return self.frame.y
        }
        set(newTop) {
            self.frame.y = newTop
        }
    }
    
    var y:CGFloat {
        get {
            return self.frame.y
        }
        
        set(newY) {
            self.frame.y = newY
        }
    }
    
    var width:CGFloat {
        get {
            return self.frame.width
        }
        
        set(newWidth) {
            self.frame.width = newWidth
        }
    }
    
    var height:CGFloat {
        get {
            return self.frame.height
        }
        
        set(newHeight) {
            self.frame.height = newHeight
        }
    }
    
    var right:CGFloat {
        get {
            return self.left + self.width
        }
        set {
            var frame = self.frame
            frame.x = newValue - frame.width
            self.frame = frame
        }
    }
    
    var bottom:CGFloat {
        get {
            return self.top + self.height
        }
        set {
            var frame = self.frame
            frame.y = newValue - frame.height
            self.frame = frame
        }
    }
    
    var centerX:CGFloat {
        get {
            return self.center.x
        }
        
        set(newCenterX) {
            var center = self.center
            center.x = newCenterX
            self.center = center
        }
    }
    
    var centerY:CGFloat {
        get {
            return self.center.y
        }
        
        set(newCenterY) {
            var center = self.center
            center.y = newCenterY
            self.center = center
        }
    }
    
    var hy_size: CGSize {
        get {
            return frame.size
        }
        set {
            var frame = self.frame
            frame.size = newValue
            self.frame = frame
        }
    }
    
    var screenWidth:CGFloat {
        return UIScreen.main.bounds.width
    }
    var screenHeight:CGFloat {
        return UIScreen.main.bounds.height
    }
    var safeTop:CGFloat {
        var result = 0.0
        if #available(iOS 11.0, *) {
            if let window = UIApplication.shared.delegate?.window,
               let safeAreaInsetsTop = window?.safeAreaInsets.top {
                result = safeAreaInsetsTop
            }
        }
        return result
    }
    var safeBottom:CGFloat {
        var result = 0.0
        if #available(iOS 11.0, *) {
            if let window = UIApplication.shared.delegate?.window,
               let safeAreaInsetsBottom = window?.safeAreaInsets.bottom {
                result = safeAreaInsetsBottom
            }
        }
        return result
    }
    var tabbarHeight:CGFloat {
        guard let tabBarController = UIApplication.shared.delegate?.window??.rootViewController as? UITabBarController else {
            return 64.0
        }
        
        let height = tabBarController.tabBar.height
        return height
    }
    /// 是否刘海屏
    var isNotch:Bool {
        get {
            var result = false
            if #available(iOS 11.0, *) {
                if let window = UIApplication.shared.delegate?.window,
                   let safeAreaInsetsBottom = window?.safeAreaInsets.bottom,
                   safeAreaInsetsBottom > 0.0 {
                    result = true
                }
            }
            return result
        }
    }
    
    func showToast(msg: String, inView view: UIView? = nil, duration: TimeInterval = 3, dismissCompletion: @escaping ()->Void = {}) {
        
        let toast: MBProgressHUD?
        if let view = view {
            toast = MBProgressHUD.showAdded(to: view, animated: true)
        }else{
            toast = MBProgressHUD.showAdded(to: (UIApplication.shared.delegate?.window!!)!, animated: true)
        }
        toast?.label.text = msg
        toast?.mode = .text
        toast?.label.numberOfLines = 0
        toast?.completionBlock = dismissCompletion
        toast?.hide(animated: true, afterDelay: duration)
    }
}

extension UIView {
    
    func toImage() -> UIImage? {
        let rect: CGRect = self.frame
        UIGraphicsBeginImageContext(rect.size)
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        self.layer.render(in: context)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img

    }
    
    func setCornerRadius(_ radius:CGFloat) {
        self.setCornerRadius(radius, 1, .white, .clear)
    }
    
    func setCornerRadius(_ radius:CGFloat, _ borderWidth: CGFloat, _ borderColor: UIColor, _ backgroundColor: UIColor) {
        let cornerImage = self.drawRectWithRoundedCorner(radius, borderWidth, borderColor, backgroundColor)
        if let bgView = self.viewWithTag(10085) as? UIImageView {
            bgView.image = cornerImage
            bgView.frame = self.bounds
        }else{
            let bgView = UIImageView.init(image: cornerImage)
            bgView.tag = 10085
            bgView.frame = self.bounds
            self.insertSubview(bgView, at: 0)
        }
    }
    
    func drawRectWithRoundedCorner(_ radius: CGFloat, _ borderWidth: CGFloat, _ borderColor: UIColor, _ backgroundColor: UIColor) -> UIImage? {
        let size = self.bounds.size
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        guard let contextRef = UIGraphicsGetCurrentContext() else {
            return nil
        }
        contextRef.setLineWidth(borderWidth)
        contextRef.setStrokeColor(borderColor.cgColor)
        contextRef.setFillColor(backgroundColor.cgColor)
        let halfBorderWidth = borderWidth / 2.0
        let width = size.width
        let height = size.height
        
        contextRef.move(to: CGPoint.init(x: width - halfBorderWidth, y: radius + halfBorderWidth))
        //右下角
        contextRef.addArc(tangent1End: CGPoint.init(x: width - halfBorderWidth, y: height - halfBorderWidth),
                          tangent2End: CGPoint.init(x: width - radius - halfBorderWidth, y: height - halfBorderWidth),
                          radius: radius)
        
        //左下角
        contextRef.addArc(tangent1End: CGPoint.init(x: halfBorderWidth, y: height - halfBorderWidth),
                          tangent2End: CGPoint.init(x: halfBorderWidth, y: height - radius - halfBorderWidth),
                          radius: radius)
        
        //左上角
        contextRef.addArc(tangent1End: CGPoint.init(x: halfBorderWidth, y: halfBorderWidth),
                          tangent2End: CGPoint.init(x: width - halfBorderWidth, y: halfBorderWidth),
                          radius: radius)
        
        //右上角
        contextRef.addArc(tangent1End: CGPoint.init(x: width - halfBorderWidth, y: halfBorderWidth),
                          tangent2End: CGPoint.init(x: width - halfBorderWidth, y: radius + halfBorderWidth),
                          radius: radius)
        
        
        contextRef.drawPath(using: .fillStroke)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
    
    func setRoundingCorners(_ radii:CGSize, roundingCorners corner:UIRectCorner) {
        
        let maskPath = UIBezierPath.init(roundedRect: self.bounds, byRoundingCorners: corner, cornerRadii: radii)
        let maskLayer = CAShapeLayer.init()
        maskLayer.path = maskPath.cgPath
        self.layer.mask = maskLayer
    }
    
    
    
    static func dashLine(_ size: CGSize, color: UIColor) -> UIView {
        let lineView = UIView.init(frame: CGRect.init(origin: .zero, size: size))
        let dashLayer = CAShapeLayer()
        dashLayer.strokeColor = color.cgColor
        dashLayer.fillColor = UIColor.clear.cgColor
        let path = UIBezierPath()
        path.move(to: .zero)
        path.addLine(to: CGPoint.init(x: size.width, y: 0))
        dashLayer.path = path.cgPath
        dashLayer.frame = lineView.bounds
        dashLayer.lineWidth = 1
        dashLayer.lineDashPattern = [3,3]
        lineView.layer.addSublayer(dashLayer)
        return lineView
    }
    
    func addRotationAnimation(){
        let keyPath = "transform.rotation"
        layer.removeAnimation(forKey: keyPath)
        let rotateAnimation = CABasicAnimation(keyPath: keyPath)
        rotateAnimation.toValue = Double.pi * 2
        rotateAnimation.duration = 5
        rotateAnimation.repeatCount = .infinity
        layer.add(rotateAnimation, forKey: keyPath)
    }
    func removeRotationAnimation(){
        let keyPath = "transform.rotation"
        layer.removeAnimation(forKey: keyPath)
    }
    
    func addScaleAnimation() {
        let keyPath = "transform.scale"
        let animation = CABasicAnimation.init(keyPath: keyPath)
        animation.fromValue = 1.0
        animation.toValue = 0.8
        animation.duration = CFTimeInterval(2)
        animation.isRemovedOnCompletion = true
        animation.fillMode = .forwards
        animation.autoreverses = true
        animation.timingFunction = CAMediaTimingFunction.init(name: CAMediaTimingFunctionName.easeInEaseOut)
        animation.repeatCount = Float(Int64.max)
        layer.add(animation, forKey: keyPath)
    }
    func removeScaleAnimation(){
        let keyPath = "transform.scale"
        layer.removeAnimation(forKey: keyPath)
        
    }
    
    func pauseAnimate() {
        let pauseTime = layer.convertTime(CACurrentMediaTime(), from: nil)
        layer.timeOffset = pauseTime
        layer.speed = 0
    }
    
    func resumeAnimate() {
        let pauseTime = layer.timeOffset
        let timeSicePause = CACurrentMediaTime() - pauseTime
        layer.timeOffset = 0
        layer.beginTime = timeSicePause
        layer.speed = 1
    }
    func resetTimeOffset() {
        layer.timeOffset = 0
//        layer.speed = 0
    }
}

extension UIView {
    
    struct AssociatedKeys {
        static var gradient = "GradientLayer"
    }
    
    enum Direction {
        case X
        case Y
    }
    
    func setGradientColor(_ colors:[UIColor],_ direction:Direction = .X) {
        switch direction {
        case .Y:
            self.setGradientColor(colors,locations: [0,1], start: CGPoint.init(x: 0, y: 0), end: CGPoint.init(x: 1.0, y: 0.0))
        default:
            self.setGradientColor(colors,locations: [0,1], start: CGPoint.init(x: 0, y: 0), end: CGPoint.init(x: 0.0, y: 1.0))
        }
    }
    
    
    func setGradientColor(_ colors:[UIColor],locations loc:[NSNumber] = [0,1], start:CGPoint = CGPoint.init(x: 0, y: 0), end: CGPoint = CGPoint.init(x: 1.0, y: 1.0)) {
        let gradientLayer:CAGradientLayer? = self.gradientLayer
        
        let block = { (_ gradientLayer:CAGradientLayer,_ colors:[UIColor],_ locations:[NSNumber], start:CGPoint, _ end: CGPoint) in
            gradientLayer.colors = colors.compactMap({ color in
                color.cgColor
            })
            gradientLayer.locations = locations
            gradientLayer.startPoint = start
            gradientLayer.endPoint = end
            gradientLayer.frame = self.bounds
            
            gradientLayer.masksToBounds = self.clipsToBounds
            gradientLayer.cornerRadius = self.layer.cornerRadius
        }
        
        guard let gradientLayer = gradientLayer else {
            let  gradientLayer = CAGradientLayer.init()
            
            self.gradientLayer = gradientLayer
            
            block(gradientLayer, colors, loc, start, end)
            
            return
        }
        
        block(gradientLayer, colors, loc, start, end)
    }
    
    
    
    var gradientLayer: CAGradientLayer? {
        set {
            self.gradientLayer?.removeFromSuperlayer()
            objc_setAssociatedObject(self, &AssociatedKeys.gradient, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            if let value = newValue {
                self.layer.insertSublayer(value, at: 0)
            }
        }
        get {
            guard let layer = objc_getAssociatedObject(self, &AssociatedKeys.gradient) as? CAGradientLayer else {
                return nil
            }
            return layer
        }
    }
    
}

extension UIView {
    
    var viewController: UIViewController? {
        for view in sequence(first: self.superview, next: {$0?.superview}){
            if let responder = view?.next as? UIViewController {
                return responder
            }
        }
        return nil
    }
}
