//
//  DetailView.swift
//  Marveland
//
//  Created by Marcelo Catach on 11/05/20.
//  Copyright © 2020 Marcelo Catach. All rights reserved.
//

import UIKit
import RxSwift

class DetailView: UIView {
    
    var title = UILabel()
    let backButton = UIButton()
    let favorite = UIButton()
    private(set) var navigation = UIView()
    private(set) var image = UIImageView()
    private(set) var comics = UITextView()
    private(set) var bio = UITextView()
    private(set) var infoStack = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    // MARK: - Life cycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func didMoveToSuperview() {
        if self.superview == nil { return }
        setupView()
        setupNavigation()
        setupFavorite()
        setupComics()
        setupImage()
        setupBio()
        setupStack()
        addSubviews()
        setupConstraints()
    }
    
    // MARK: - View setup
    
    private func setupFavorite() {
        favorite.backgroundColor = UIColor.init(red: 251/255, green: 244/255, blue: 75/255, alpha: 1)
        favorite.layer.borderColor = CGColor.init(srgbRed: 0, green: 0, blue: 0, alpha: 1)
        favorite.layer.borderWidth = 2
    }
        
    private func setupView() {
        self.backgroundColor = .black
    }
    
    private func setupNavigation() {
        backButton.setTitle("<", for: .normal)
        backButton.setTitleColor(.white, for: .normal)
        backButton.titleLabel?.font = .boldSystemFont(ofSize: 28)
        
        title.font = .boldSystemFont(ofSize: 24)
        title.adjustsFontSizeToFitWidth = true
        title.minimumScaleFactor = 0.5
        title.textAlignment = .center
        title.textColor = .white
        
        self.navigation.addSubview(backButton)
        self.navigation.addSubview(title)
    }
    
    private func setupImage() {
        image.isUserInteractionEnabled = true
        image.backgroundColor = .black
        image.layer.borderColor = CGColor.init(srgbRed: 1, green: 1, blue: 1, alpha: 1)
        image.layer.borderWidth = 5
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFit
        
        image.addSubview(favorite)
    }
    
    private func setupComics() {
        comics.isEditable = false
        comics.backgroundColor = .darkGray
        comics.textColor = .white
        comics.font = .systemFont(ofSize: 16)
        comics.textContainer.lineBreakMode = .byTruncatingTail
        comics.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }

    private func setupBio() {
        bio.isEditable = false
        bio.backgroundColor = .yellow
        bio.textColor = .black
        bio.layer.borderColor = CGColor.init(srgbRed: 0, green: 0, blue: 0, alpha: 1)
        bio.layer.borderWidth = 5
        bio.font = .italicSystemFont(ofSize: 16)
        bio.textContainer.lineBreakMode = .byTruncatingTail
        bio.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        bio.isScrollEnabled = false
    }

    private func setupStack() {
        infoStack.axis = .vertical
        infoStack.alignment = .fill // .Leading .FirstBaseline .Center .Trailing .LastBaseline
        infoStack.distribution = .fill // .FillEqually .FillProportionally .EqualSpacing .EqualCentering

        infoStack.addArrangedSubview(bio)
        infoStack.addArrangedSubview(comics)
    }
            
    private func addSubviews() {
        let subviews = [navigation, image, infoStack]
        subviews.forEach(addSubview)
    }

    private func setupConstraints() {
        self.snp.makeConstraints { (make) in
            make.top.width.bottom.height.equalToSuperview()
        }
        
        backButton.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().inset(10)
            make.width.height.equalTo(44)
        }
        
        title.snp.makeConstraints { make in
            make.centerX.top.equalToSuperview()
            make.height.equalTo(45)
            make.left.equalTo(backButton.snp.right)
        }
        
        navigation.snp.makeConstraints { (make) in
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top)
            make.height.equalTo(45)
            make.leading.trailing.equalToSuperview()
        }

        image.snp.makeConstraints { (make) in
            make.top.equalTo(navigation.snp.bottom)
            make.width.equalToSuperview()
            make.height.equalTo(CGFloat.imageHeight)
        }
        
        favorite.snp.makeConstraints { (make) in
            make.top.left.equalToSuperview().inset(7)
            make.width.equalTo(44)
            make.height.equalTo(44)
        }
        
        bio.snp.makeConstraints { (make) in
            make.height.equalTo(200)
        }
        
        infoStack.snp.makeConstraints { (make) in
            make.top.equalTo(self.image.snp.bottom)
            make.width.bottom.equalToSuperview()
        }
    }
}

private extension CGFloat {
    static let imageHeight: CGFloat = 300
    static let cellInset: CGFloat = 10
}
