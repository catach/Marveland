//
//  DetailViewController.swift
//  Marveland
//
//  Created by Marcelo Catach on 11/05/20.
//  Copyright © 2020 Marcelo Catach. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Moya
import Kingfisher

class DetailViewController: UIViewController {
    private var containerView = DetailView()
    private let disposeBag = DisposeBag()
    private var model: CharacterModel?
    
    init(model: CharacterModel) {
        super.init(nibName: nil, bundle: nil)
        self.model = model
    }
    
    override func loadView() {
        self.view = containerView
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupBindings()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    private func setupView() {
        let url = URL(string: model?.imageLandscape ?? "")
        containerView.image.kf.setImage(with: url)
        containerView.title.text = model?.name ?? ""
        
        containerView.bio.text = "N/A"
        if let description = model?.description {
            containerView.bio.text = description.isEmpty ? "Bio N/A" : "\"\(description)\""
        }
        
        let allComics = model?.comicsName.joined(separator: "\n") ?? "N/A"
        
        if let comicsAppearances = model?.comicsAppearances {
            containerView.comics.text = "Appears on \(comicsAppearances) Comics like: \n\(allComics)"
        } else {
            containerView.comics.text = "Appears on Comics like: \n\(allComics)"
        }
        
    }
    
    private func setupBindings() {
        containerView.backButton.rx.tap
            .bind(to: rx.backButton)
            .disposed(by: disposeBag)
    }
    
    internal func back() {
        do {
            try self.parentCoordinator?.handle(event: AppCoordinatorEvent.backHome)
        } catch {
            fatalError("Can't handle event \(error)")
        }
        
    }
}

// MARK: - Binders and extension

extension Reactive where Base: DetailViewController {
        
    var backButton: Binder<()> {
        return Binder(base) { controller, _ in
            controller.back()
        }
    }
}
