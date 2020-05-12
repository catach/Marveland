//
//  AppCoordinator.swift
//  Marveland
//
//  Created by Marcelo Catach on 06/05/20.
//  Copyright © 2020 Marcelo Catach. All rights reserved.
//

import UIKit

enum AppCoordinatorEvent: AppEvent {
    case openHome
    case showDetail(model: CharacterModel)
    case backHome
}

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
        setupEvents()
        super.start(with: completion)
    }

    private func setupEvents() {
        add(eventType: AppCoordinatorEvent.self) { [weak self] event in
            switch event {
            case .openHome:
                self?.setupTabBar()
                self?.startChild(coordinator: HomeCoordinator(rootViewController: self?.rootViewController))
            case .showDetail(let model):
                let navController = self?.rootViewController as? UINavigationController
                let controller = DetailViewController(model: model)
                controller.parentCoordinator = self
                navController?.pushViewController(controller, animated: true)
            case .backHome:
                let navController = self?.rootViewController as? UINavigationController
                navController?.popViewController(animated: true)
            }
        }
    }

    private func setupTabBar() {
        let tabBarController = UITabBarController()
        let navController = UINavigationController(rootViewController: tabBarController)
        navController.navigationBar.isHidden = true
        self.rootViewController = navController
        self.rootViewController?.parentCoordinator = self
        self.window?.rootViewController = self.rootViewController
    }
}
