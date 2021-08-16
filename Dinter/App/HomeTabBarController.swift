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
        
        UITabBar.appearance().tintColor = .greenCustomized
        UITabBar.appearance().barTintColor = .white // Background TabBar - 1F1F21
        
        let startViewController = ViewController()
        startViewController.title = "Match"
        startViewController.tabBarItem.image = UIImage(named: "match")
        
        let profileViewController = ProfileUserViewController()
        profileViewController.title = "Profile"
        profileViewController.tabBarItem.image = UIImage(named: "profile")
        
        
        // let navViewController = UINavigationController(rootViewController: )
        
        let profileNavViewController = UINavigationController(rootViewController: profileViewController)
        
        viewControllers = [startViewController, profileNavViewController]
    }
    
    
}

