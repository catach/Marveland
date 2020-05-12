//
//  DetailView.swift
//  Marveland
//
//  Created by Marcelo Catach on 11/05/20.
//  Copyright © 2020 Marcelo Catach. All rights reserved.
//

import UIKit

class DetailView: UIView {
    
    private(set) var image = UIImageView()
    private(set) var name = UITextView()
    private(set) var comics = UITextView()
    private(set) var bio = UITextView()
    private(set) var infoStack = UIStackView()
        
    // MARK: - Life cycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        setupView()
        setupName()
        setupComics()
        setupBio()
        setupStack()
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
    
    private func setupName() {
        name.text = ""
        name.backgroundColor = UIColor.init(red: 251/255, green: 244/255, blue: 75/255, alpha: 1)
        name.textColor = .black
        name.layer.borderColor = CGColor.init(srgbRed: 0, green: 0, blue: 0, alpha: 1)
        name.layer.borderWidth = 2
        name.font = UIFont.boldSystemFont(ofSize: 12)
        name.textContainer.maximumNumberOfLines = 2
        name.textContainer.lineBreakMode = .byTruncatingTail
        name.textContainerInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        name.isScrollEnabled = false
    }

    private func setupComics() {
        comics.text = ""
        comics.backgroundColor = .blue
        comics.textColor = .black
        comics.layer.borderColor = CGColor.init(srgbRed: 0, green: 0, blue: 0, alpha: 1)
        comics.layer.borderWidth = 2
        comics.font = UIFont.boldSystemFont(ofSize: 12)
        comics.textContainer.maximumNumberOfLines = 2
        comics.textContainer.lineBreakMode = .byTruncatingTail
        comics.textContainerInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        comics.isScrollEnabled = false
    }

    private func setupBio() {
        bio.text = ""
        bio.backgroundColor = .white
        bio.textColor = .black
        bio.layer.borderColor = CGColor.init(srgbRed: 0, green: 0, blue: 0, alpha: 1)
        bio.layer.borderWidth = 2
        bio.font = UIFont.boldSystemFont(ofSize: 12)
        bio.textContainer.maximumNumberOfLines = 2
        bio.textContainer.lineBreakMode = .byTruncatingTail
        bio.textContainerInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        bio.isScrollEnabled = false
    }

    private func setupStack() {
        infoStack.axis = .vertical
        infoStack.alignment = .fill // .Leading .FirstBaseline .Center .Trailing .LastBaseline
        infoStack.distribution = .fill // .FillEqually .FillProportionally .EqualSpacing .EqualCentering

        infoStack.addArrangedSubview(name)
        infoStack.addArrangedSubview(comics)
        infoStack.addArrangedSubview(bio)
         // for vertical stack view, you might want to add height constraint to label or whatever view you're adding.
    }
            
    private func addSubviews() {
        let subviews = [image, infoStack]
        subviews.forEach(addSubview)
    }

    private func setupConstraints() {
        image.snp.makeConstraints { (make) in
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top)
            make.width.equalToSuperview()
            make.height.equalTo(CGFloat.imageHeight)
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
