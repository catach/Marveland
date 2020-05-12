//
//  DetailView.swift
//  Marveland
//
//  Created by Marcelo Catach on 11/05/20.
//  Copyright © 2020 Marcelo Catach. All rights reserved.
//

import UIKit

class DetailView: UIView {
    
    var title = UILabel()
    let backButton = UIButton()
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
        setupComics()
        setupBio()
        setupStack()
        addSubviews()
        setupConstraints()
    }
    
    // MARK: - View setup
        
    private func setupView() {
        self.backgroundColor = .white
    }
    
    private func setupNavigation() {
        backButton.setTitle("<", for: .normal)
        backButton.setTitleColor(.black, for: .normal)
        backButton.titleLabel?.font = .boldSystemFont(ofSize: 28)
        
        title.font = .boldSystemFont(ofSize: 24)
        
        self.navigation.addSubview(backButton)
        self.navigation.addSubview(title)
        
        backButton.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(10)
            make.width.height.equalTo(45)
        }
        
        title.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(10)
            make.height.equalTo(45)
        }
    }
    
    private func setupImage() {
        image.backgroundColor = .white
        image.layer.borderColor = CGColor.init(srgbRed: 1, green: 0, blue: 0, alpha: 1)
        image.layer.borderWidth = 5
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFit
    }
    
    private func setupComics() {
        comics.backgroundColor = .darkGray
        comics.textColor = .white
        comics.font = .systemFont(ofSize: 16)
        comics.textContainer.lineBreakMode = .byTruncatingTail
        comics.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }

    private func setupBio() {
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
        self.snp.makeConstraints { make in
            make.top.width.bottom.height.equalToSuperview()
        }
        
        navigation.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top)
            make.height.equalTo(60)
            make.leading.trailing.equalToSuperview()
        }

        image.snp.makeConstraints { (make) in
            make.top.equalTo(navigation.snp.bottom)
            make.width.equalToSuperview()
            make.height.equalTo(CGFloat.imageHeight)
        }
        
        bio.snp.makeConstraints { make in
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
