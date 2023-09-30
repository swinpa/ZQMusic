//
//  ZQMTabBarController.swift
//  ZQMusic
//
//  Created by wp on 9/30/23.
//

import UIKit
@_exported import ESTabBarController_swift


class ZQMTabBarController: ESTabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    static func tabBarController() -> ZQMTabBarController {
        let tabBarController = ZQMTabBarController()
        
        
        let v1 = HomeViewController()
        let v2 = MeViewController()
        v1.tabBarItem = Self.makeTabBarItem(imageName: "home")
        v2.tabBarItem = Self.makeTabBarItem(imageName: "me")
        tabBarController.viewControllers = [
            ZQMNavigationController.init(rootViewController: v1),
            ZQMNavigationController.init(rootViewController: v2)
        ]
        
        if let tabBar = tabBarController.tabBar as? ESTabBar {
        
            if #available(iOS 13, *) {
                let tabbarAppearance = UITabBarAppearance()
                tabbarAppearance.backgroundImage = UIImage.init(color: UIColor.clear)
                tabbarAppearance.shadowImage = UIImage.init(color: UIColor.clear)
                tabbarAppearance.stackedItemPositioning = .centered
                tabbarAppearance.configureWithTransparentBackground()
                tabBar.standardAppearance = tabbarAppearance
                if #available(iOS 15, *) {
                    tabBar.scrollEdgeAppearance = tabbarAppearance
                }
            }else{
                tabBar.backgroundImage = UIImage()
                tabBar.shadowImage = UIImage()
            }
            
            //设置图标布局方式
            tabBar.itemCustomPositioning = .centered//.fillIncludeSeparator
        }
        
        return tabBarController
    }
    fileprivate static func makeTabBarItem(_ title: String? = nil, imageName:String) -> ESTabBarItem {
        let itemContentView = ESTabBarItemContentView()
        itemContentView.renderingMode = .alwaysOriginal
        itemContentView.titleLabel.isHidden = true
        return ESTabBarItem.init(itemContentView, title: nil, image: UIImage(named: "tabbar_\(imageName)_normal"), selectedImage: UIImage(named: "tabbar_\(imageName)_selected"))
    }

}
