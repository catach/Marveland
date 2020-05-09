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
            }
        }
    }

    private func setupTabBar() {
        let tabBarController = UITabBarController()
        self.rootViewController = tabBarController
        self.window?.rootViewController = self.rootViewController
    }
}
