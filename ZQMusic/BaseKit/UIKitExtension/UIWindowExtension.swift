//
//  UIWindowExtension.swift
//  KLChat
//
//  Created by lw on 2022/3/16.
//

import UIKit

extension UIWindow {
    static var current:UIWindow? {
        get {
            return UIApplication.shared.delegate?.window ?? nil
        }
    }
    
    var rootNavigationController: UINavigationController? {
        get {
            guard let root = rootViewController else { return nil }
            return getNavigationController(vc: root)
        }
    }
    
    var topController: UIViewController? {
        guard let root = rootViewController else { return nil }
        return getTopController(vc: root)
    }
    
    func getNavigationController(vc:UIViewController) -> UINavigationController? {
        if let navi = vc as? UINavigationController {
            return navi
        }
        if let tabController = vc as? UITabBarController {
            guard let current = tabController.selectedViewController else {
                return nil
            }
            return getNavigationController(vc: current)
        }
        return vc.navigationController
    }
    
    
    func getTopController(vc:UIViewController) -> UIViewController? {
        
        if let navi = vc as? UINavigationController, let top = navi.topViewController {
            return getTopController(vc: top)
        }
        if let tabController = vc as? UITabBarController {
            guard let current = tabController.selectedViewController else {
                return nil
            }
            return getTopController(vc: current)
        }
        if let pre = vc.presentedViewController {
            return getTopController(vc: pre)
        }
        
        return vc
    }
}
