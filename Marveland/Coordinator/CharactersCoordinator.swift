//
//  CharactersCoordinator.swift
//  Marveland
//
//  Created by Marcelo Catach on 13/05/20.
//  Copyright © 2020 Marcelo Catach. All rights reserved.
//

import UIKit

enum CharactersCoordinatorEvent: AppEvent {
    case showDetail(model: CharacterModel, viewModel: CharactersViewModel?)
    case showCharacters
}

class CharactersCoordinator: Coordinator {
    
    override func start(with completion: @escaping () -> Void = {}) {
        let charactersViewController = CharactersViewController()

        charactersViewController.tabBarItem = UITabBarItem(title: "Characters", image: UIImage(named: "charIcon"), tag: 0)
        charactersViewController.parentCoordinator = self

        let root = self.rootViewController as? UINavigationController
        if let tabBarController = root?.topViewController as? UITabBarController {
            if tabBarController.viewControllers == nil {
                tabBarController.viewControllers = [charactersViewController]
            } else {
                tabBarController.viewControllers?.append(charactersViewController)
            }
        } else {
            fatalError(String(describing: type(of: self.rootViewController)))
        }
        
        setupEvents()
        
        super.start(with: completion)
    }
    
    private func setupEvents() {
        self.add(eventType: CharactersCoordinatorEvent.self) { [weak self] event in
            switch event {
            case .showDetail(let model, let viewModel):
                let navController = self?.rootViewController as? UINavigationController
                let controller = DetailViewController(model: model, viewModel: viewModel)
                controller.parentCoordinator = self
                navController?.pushViewController(controller, animated: true)
                
            case .showCharacters:
                let navController = self?.rootViewController as? UINavigationController
                navController?.popViewController(animated: true)
            }
        }
    }
}
