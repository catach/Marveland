//
//  DetailCoordinator.swift
//  Marveland
//
//  Created by Marcelo Catach on 13/05/20.
//  Copyright © 2020 Marcelo Catach. All rights reserved.
//

import UIKit

enum DetailCoordinatorEvent: AppEvent {
    case dismiss
}

class DetailCoordinator: Coordinator {
    
    private var model: CharacterModel?
    private var favoriteManager = FavoriteManager()
    
    public init(_ rootViewController: UIViewController?, _ model: CharacterModel) {
        super.init(rootViewController: rootViewController)
        self.model = model
    }
    
    override func start(with completion: @escaping () -> Void = {}) {
        guard let model = model else { return }
        
        let detailViewController = DetailViewController(model: model)
                
        detailViewController.parentCoordinator = self
        
        let root = self.rootViewController as? UINavigationController
        root?.pushViewController(detailViewController, animated: true)
        
        setupEvents()
        
        super.start(with: completion)
    }
    
    private func setupEvents() {
        self.add(eventType: DetailCoordinatorEvent.self) { [weak self] event in
            switch event {
            case .dismiss:
                let navController = self?.rootViewController as? UINavigationController
                navController?.popViewController(animated: true)
                self?.stop()
            }
        }
    }
}
