//
//  UIViewControllerExtension.swift
//  KLChat
//
//  Created by lw on 2022/3/15.
//

import Foundation
import UIKit

extension UIViewController {
    var screenWidth:CGFloat {
        return self.view.screenWidth
    }
    var screenHeight:CGFloat {
        return self.view.screenHeight
    }
    var safeTop:CGFloat {
        self.view.safeTop
    }
    var safeBottom:CGFloat {
        self.view.safeBottom
    }
    var tabbarHeight:CGFloat {
        self.view.tabbarHeight
    }
    /// 是否刘海屏
    var isNotch:Bool {
        return self.view.isNotch
    }
    
    func showToast(msg: String, inView view: UIView? = nil, duration: TimeInterval = 3, dismissCompletion: @escaping ()->Void = {}) {
        self.view.showToast(msg: msg, inView: view, duration: duration, dismissCompletion: dismissCompletion)
    }
}

