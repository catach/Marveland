//
//  FavoritesView.swift
//  Marveland
//
//  Created by Marcelo Catach on 07/05/20.
//  Copyright © 2020 Marcelo Catach. All rights reserved.
//

import UIKit

class FavoritesView: UIView {
    private(set) lazy var collectionView = buildCollectionView()
        
    // MARK: - Life cycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        setupView()
        addSubviews()
        setupConstraints()
    }
    
    private func buildCollectionView() -> UICollectionView {
           let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
           layout.sectionInset = UIEdgeInsets(
               top: .cellInset,
               left: .cellInset,
               bottom: 0,
               right: .cellInset
           )
           layout.minimumInteritemSpacing = .cellInset

           let collectionView = UICollectionView(frame: self.frame, collectionViewLayout: layout)
           collectionView.backgroundColor = .white
           return collectionView
       }
       
    // MARK: - View setup
    
    private func setupView() {
        self.snp.makeConstraints { make in
            make.top.width.bottom.height.equalToSuperview()
        }
        
        self.backgroundColor = .white
    }
    
    private func addSubviews() {
        let subviews = [collectionView]
        subviews.forEach(addSubview)
    }

    private func setupConstraints() {
        collectionView.snp.makeConstraints { (make) in
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top)
            make.width.bottom.equalToSuperview()
        }
    }
}

private extension CGFloat {
    static let cellInset: CGFloat = 10
}
