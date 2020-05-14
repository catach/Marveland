//
//  AppCoordinator.swift
//  Marveland
//
//  Created by Marcelo Catach on 06/05/20.
//  Copyright © 2020 Marcelo Catach. All rights reserved.
//

import UIKit

class AppCoordinator: Coordinator {

    private let window: UIWindow?

    init(window: UIWindow?) {
        self.window = window
        super.init(rootViewController: nil)
    }

    private func setupWindow() {
        window?.backgroundColor = .black
        window?.makeKeyAndVisible()
    }

    override func start(with completion: @escaping () -> Void = {}) {
        setupWindow()
        setupTabBar()
        super.start(with: completion)
    }

    private func setupTabBar() {
        let tabBarController = UITabBarController()
        let navController = UINavigationController(rootViewController: tabBarController)
        navController.navigationBar.isHidden = true
        
        self.rootViewController = navController
        self.rootViewController?.parentCoordinator = self
        self.window?.rootViewController = self.rootViewController
        
        let charactersCoordinator = CharactersCoordinator(rootViewController: navController)
        let favoritesCoordinator = FavoritesCoordinator(rootViewController: navController)
        
        self.startChild(coordinator: charactersCoordinator)
        self.startChild(coordinator: favoritesCoordinator)
        
        tabBarController.selectedIndex = 0
    }
}
