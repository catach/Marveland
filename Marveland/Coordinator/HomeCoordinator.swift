//
//  HomeCoordinator.swift
//  Marveland
//
//  Created by Marcelo Catach on 07/05/20.
//  Copyright © 2020 Marcelo Catach. All rights reserved.
//

import UIKit

class HomeCoordinator: Coordinator {
    
    private var homeNavigationViewController: UINavigationController?
    private var homeTabViewController: UITabBarController?
    
    override init(rootViewController: UIViewController?) {
        super.init(rootViewController: rootViewController)
        homeNavigationViewController = rootViewController as? UINavigationController
        homeTabViewController = homeNavigationViewController?.topViewController as? UITabBarController
    }
     
    override func start(with completion: @escaping () -> Void = {}) {
        
        let charactersViewController = CharactersViewController()
        charactersViewController.parentCoordinator = self
        charactersViewController.tabBarItem = UITabBarItem(title: "Characters", image: UIImage(named: "charIcon"), tag: 0)
        let favoritesViewController = FavoritesViewController()
        favoritesViewController.parentCoordinator = self
        favoritesViewController.tabBarItem = UITabBarItem(title: "Favorites", image: UIImage(named: "favIcon"), tag: 1)

        let tabBarList = [charactersViewController, favoritesViewController]

        homeTabViewController?.viewControllers = tabBarList
        homeTabViewController?.selectedIndex = 0
        
        super.start(with: completion)
    }
}
