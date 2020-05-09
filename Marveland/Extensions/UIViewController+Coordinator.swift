//
//  UIViewController+Coordinator.swift
//  Marveland
//
//  Created by Marcelo Catach on 07/05/20.
//  Copyright © 2020 Marcelo Catach. All rights reserved.
//

import UIKit

extension UIViewController {

    private struct AssociatedKeys {
        static var ParentCoordinator = "ParentCoordinator"
    }

    weak var parentCoordinator: Coordinator? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.ParentCoordinator) as? Coordinator
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.ParentCoordinator, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
    }
}
