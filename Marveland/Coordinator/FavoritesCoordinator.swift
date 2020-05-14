//
//  FavoritesCoordinator.swift
//  Marveland
//
//  Created by Marcelo Catach on 13/05/20.
//  Copyright © 2020 Marcelo Catach. All rights reserved.
//

import UIKit

class FavoritesCoordinator: Coordinator {
    override func start(with completion: @escaping () -> Void = {}) {
        let favoritesViewController = FavoritesViewController()
                
        favoritesViewController.tabBarItem = UITabBarItem(title: "Favorites", image: UIImage(named: "favIcon"), tag: 1)
        favoritesViewController.parentCoordinator = self
        
        let root = self.rootViewController as? UINavigationController
        if let tabBarController = root?.topViewController as? UITabBarController {
            if tabBarController.viewControllers == nil {
                tabBarController.viewControllers = [favoritesViewController]
            } else {
                tabBarController.viewControllers?.append(favoritesViewController)
            }
        } else {
            fatalError(String(describing: type(of: self.rootViewController)))
        }
        
        super.start(with: completion)
    }

}
