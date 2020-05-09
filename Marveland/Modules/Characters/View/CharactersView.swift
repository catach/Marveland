//
//  CharactersView.swift
//  Marveland
//
//  Created by Marcelo Catach on 07/05/20.
//  Copyright © 2020 Marcelo Catach. All rights reserved.
//

import UIKit

class CharactersView: UIView {
    
    private var searchBar = UISearchBar()
    private(set) var collectionView: UICollectionView?
    
    // MARK: - Life cycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        setupView()
        setupSearchBar()
        setupCollectionView()
        addSubviews()
        setupConstraints()
    }
    
    // MARK: - View setup
    
    private func setupView() {
        self.snp.makeConstraints { make in
            make.top.width.bottom.height.equalToSuperview()
        }
        
        self.backgroundColor = .white
    }
    
    private func setupSearchBar() {
        searchBar.searchBarStyle = .minimal
        searchBar.isTranslucent = false
    }
    
    private func setupCollectionView() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(
            top: .cellInset,
            left: .cellInset,
            bottom: 0,
            right: .cellInset
        )
        layout.minimumInteritemSpacing = .cellInset

        collectionView = UICollectionView(frame: self.frame, collectionViewLayout: layout)
        collectionView?.backgroundColor = .white
    }
    
    private func addSubviews() {
        let subviews = [searchBar, collectionView ?? UICollectionView()]
        subviews.forEach(addSubview)
    }

    private func setupConstraints() {
        searchBar.snp.makeConstraints { (make) in
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top)
            make.width.equalToSuperview()
            make.height.equalTo(CGFloat.searchBarHeight)
        }
        
        collectionView?.snp.makeConstraints { (make) in
            make.top.equalTo(self.searchBar.snp.bottom)
            make.width.bottom.equalToSuperview()
        }
    }
}

private extension CGFloat {
    static let searchBarHeight: CGFloat = 40
    static let cellInset: CGFloat = 10
}
