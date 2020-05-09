//
//  CharacterCollectionViewCell.swift
//  Marveland
//
//  Created by Marcelo Catach on 08/05/20.
//  Copyright © 2020 Marcelo Catach. All rights reserved.
//

import UIKit

class CharacterCollectionViewCell: UICollectionViewCell {
    
    let name: UITextView = {
        let view = UITextView()
        view.text = ""
        view.backgroundColor = UIColor.init(red: 251/255, green: 244/255, blue: 75/255, alpha: 1)
        view.textColor = .black
        view.layer.borderColor = CGColor.init(srgbRed: 0, green: 0, blue: 0, alpha: 1)
        view.layer.borderWidth = 2
        view.font = UIFont.boldSystemFont(ofSize: 12)
        view.textContainer.maximumNumberOfLines = 2
        view.textContainer.lineBreakMode = .byTruncatingTail
        view.textContainerInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        view.isScrollEnabled = false
        return view
    }()
    
    let thumbnail: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .white
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFill
        view.image = UIImage()
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .yellow
        addSubviews()
        setupConstraints()
    }
    
    private func setupConstraints() {
        name.snp.makeConstraints { (make) in
            make.left.top.equalToSuperview().inset(7)
            make.width.width.lessThanOrEqualToSuperview().inset(10)
        }
        name.setContentCompressionResistancePriority(
            UILayoutPriority(rawValue: 1000),
            for: .vertical
        )
        
        thumbnail.snp.makeConstraints { (make) in
            make.left.top.width.height.equalToSuperview()
        }
    }
    
    private func addSubviews() {
        addSubview(thumbnail)
        addSubview(name)
    }
    
    override func prepareForReuse() {
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
