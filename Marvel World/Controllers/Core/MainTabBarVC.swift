//
//  MainTabBarVC.swift
//  Marvel World
//
//  Created by Abdullah Al Sohel on 5/15/22.
//

import UIKit


class MainTabBarVC: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let homeVC = UINavigationController(rootViewController: HomeVC())
        let downloadsVC = UINavigationController(rootViewController: DownloadsVC())
        
        
        homeVC.tabBarItem.title = "Characters"
        homeVC.tabBarItem.image = UIImage(systemName: "person.3.sequence.fill")
        
        downloadsVC.tabBarItem.title = "Downloads"
        downloadsVC.tabBarItem.image = UIImage(systemName: "arrow.down")
        
        tabBar.tintColor = .label
        
        
        setViewControllers([homeVC, downloadsVC], animated: true)
    }

}
