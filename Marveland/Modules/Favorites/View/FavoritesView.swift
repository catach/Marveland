//
//  FavoritesView.swift
//  Marveland
//
//  Created by Marcelo Catach on 07/05/20.
//  Copyright © 2020 Marcelo Catach. All rights reserved.
//

import UIKit

class FavoritesView: UIView {
    
    private var searchBar = UISearchBar()
    
    // MARK: - Life cycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        addSubviews()
        setupConstraints()
    }
    
    // MARK: - View setup
    
    private func addSubviews() {
        let subviews = [searchBar]
        subviews.forEach(addSubview)
    }

    private func setupConstraints() {
        searchBar.snp.makeConstraints { make in
            make.top.width.equalToSuperview()
            make.height.equalTo(CGFloat.searchBarHeight)
        }
    }
}

private extension CGFloat {
    static let searchBarHeight = 40
}
