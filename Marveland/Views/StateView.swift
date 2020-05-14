//
//  StateView.swift
//  Marveland
//
//  Created by Marcelo Catach on 14/05/20.
//  Copyright © 2020 Marcelo Catach. All rights reserved.
//

import UIKit
import SnapKit

enum State {
    case loading
    case empty
    case error
}

class StateView: UIView {
    
    private(set) var image = UIImageView()
    private(set) var text = UILabel()
    private(set) var state = State.loading
    
    init(state: State) {
        self.state = state
        super.init(frame: CGRect.zero)
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
        setupImage()
        setupText()
        addSubviews()
        setupConstraints()
    }
        
    // MARK: - View setup
    
    private func setupView() {
        self.backgroundColor = .white
    }
    
    private func addSubviews() {
        let subviews = [image, text]
        subviews.forEach(addSubview)
    }
    
    private func setupImage() {
        image.isUserInteractionEnabled = true
        image.backgroundColor = .white
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFit
        switch state {
        case .empty:
            image.image = UIImage(named: "empty")
        case .error:
            image.image = UIImage(named: "error")
        case .loading:
            image.image = UIImage(named: "loading")
        }
    }
    
    private func setupText() {
        text.backgroundColor = .clear
        text.textColor = .black
        text.font = .systemFont(ofSize: 30)
        switch state {
        case .empty:
            text.text = "Nothing to see here"
        case .error:
            text.text = "Something went wrong"
        case .loading:
            text.text = "Loading..."
        }

    }

    private func setupConstraints() {
        self.snp.makeConstraints { make in
            make.top.width.bottom.height.equalToSuperview()
        }
        
        image.snp.makeConstraints { (make) in
            make.width.height.equalTo(300)
            make.centerY.centerX.equalToSuperview()
        }
        
        text.snp.makeConstraints { (make) in
            make.top.equalTo(image.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.height.equalTo(40)
        }
    }
}
