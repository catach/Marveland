//
//  FavoritesViewController.swift
//  Marveland
//
//  Created by Marcelo Catach on 07/05/20.
//  Copyright © 2020 Marcelo Catach. All rights reserved.
//

import UIKit

class FavoritesViewController: UIViewController {
    let containerView = FavoritesView()
   
    override func loadView() {
        view = containerView
    }
}
