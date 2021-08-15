//
//  HomeTabBarController.swift
//  Dinter
//
//  Created by Luis Segoviano on 15/08/21.
//

import UIKit

class HomeTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.layer.borderWidth = 0.0
        tabBar.layer.borderColor = UIColor.clear.cgColor
        tabBar.clipsToBounds = true
        
        UITabBar.appearance().tintColor = hexStringToUIColor(hex: "21b384") // Items
        UITabBar.appearance().barTintColor = .white // Background TabBar - 1F1F21
        
        let startViewController = ViewController()
        startViewController.title = "Match"
        startViewController.tabBarItem.image = UIImage(named: "match")
        
        let profileViewController = ProfileUserViewController()
        profileViewController.title = "Profile"
        profileViewController.tabBarItem.image = UIImage(named: "profile")
        
        
        let navViewController = UINavigationController(rootViewController: startViewController)
        
        let profileNavViewController = UINavigationController(rootViewController: profileViewController)
        
        viewControllers = [navViewController, profileNavViewController]
    }
    
    
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
}

