//
//  HomeCoordinator.swift
//  Marveland
//
//  Created by Marcelo Catach on 07/05/20.
//  Copyright © 2020 Marcelo Catach. All rights reserved.
//

import UIKit

enum HomeCoordinatorEvent: AppEvent {
    case openCharacters
    case openFavorites
}

class HomeCoordinator: Coordinator {
    
    private var homeViewController: UITabBarController?
    
    override init(rootViewController: UIViewController?) {
        super.init(rootViewController: rootViewController)
        homeViewController = rootViewController as? UITabBarController
    }
     
    override func start(with completion: @escaping () -> Void = {}) {
        setupEvents()
        
        let charactersViewController = CharactersViewController()
        charactersViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 0)

        let favoritesViewController = FavoritesViewController()
        favoritesViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .more, tag: 1)

        let tabBarList = [charactersViewController, favoritesViewController]

        homeViewController?.viewControllers = tabBarList
        
        do {
            try self.handle(event: HomeCoordinatorEvent.openCharacters)
        } catch {
            if case let AppEventError.eventNotHandled(event) = error {
                fatalError("event not handled: [\(String(reflecting: type(of: event)))]")
            }
        }
        super.start(with: completion)
    }

    private func setupEvents() {
        add(eventType: HomeCoordinatorEvent.self) { [weak self] event in
            switch event {
            case .openCharacters:
                self?.homeViewController?.selectedIndex = 0
            case .openFavorites:
                self?.homeViewController?.selectedIndex = 1
            }
        }
    }
}
