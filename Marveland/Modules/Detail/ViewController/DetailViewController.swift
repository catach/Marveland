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
    private var viewModel: CharactersViewModel?
    private let favoritesManager = FavoriteManager()
    
    init(model: CharacterModel) {
        super.init(nibName: nil, bundle: nil)
        self.model = model
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = containerView
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
        if let bio = model?.bio {
            containerView.bio.text = bio.isEmpty ? "Bio N/A" : "\"\(bio)\""
        }
        
        let allComics = model?.comicsName.joined(separator: "\n") ?? "N/A"
        
        if let comicsAppearances = model?.comicsAppearances {
            if comicsAppearances == 0 {
                containerView.comics.text = "N/A"
            } else {
                containerView.comics.text = "Appears on \(comicsAppearances) Comics like: \n\(allComics)"
            }
        } else {
            containerView.comics.text = "Appears on Comics like: \n\(allComics)"
        }
        
        if favoritesManager.isFavorite(model?.charId ?? 0) {
            containerView.favorite.setImage(UIImage(named: "onFav"), for: .normal)
        } else {
            containerView.favorite.setImage(UIImage(named: "offFav"), for: .normal)
        }
    }
    
    private func setupBindings() {
        containerView.favorite.rx.tap
            .bind(to: rx.favoriteTap)
            .disposed(by: disposeBag)

        containerView.backButton.rx.tap
            .bind(to: rx.backButton)
            .disposed(by: disposeBag)
    }
    
    internal func back() {
        do {
            try self.parentCoordinator?.handle(event: DetailCoordinatorEvent.dismiss)
        } catch {
            fatalError("Can't handle event \(error)")
        }
    }
    
    internal func favoriteTap() {
        if favoritesManager.toggleFavorite(self.model) == true {
            containerView.favorite.setImage(UIImage(named: "onFav"), for: .normal)
        } else {
            containerView.favorite.setImage(UIImage(named: "offFav"), for: .normal)
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
    
    var favoriteTap: Binder<()> {
        return Binder(base) { controller, _ in
            controller.favoriteTap()
        }
    }
}
