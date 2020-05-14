//
//  FavoritesViewController.swift
//  Marveland
//
//  Created by Marcelo Catach on 07/05/20.
//  Copyright © 2020 Marcelo Catach. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class FavoritesViewController: UIViewController {
    let containerView = FavoritesView()
    internal let emptyView = StateView(state: .empty)
    internal let loadingView = StateView(state: .loading)
    internal let errorView = StateView(state: .error)
    private let disposeBag = DisposeBag()
    internal var characters: BehaviorSubject<[CharacterModel]> = BehaviorSubject(value: [])
    private var viewModel = FavoritesViewModel()
    
    override func loadView() {
        view = containerView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        containerView.collectionView.delegate = self
        
        setupBindings()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        viewModel.getFavorites()
            .bind(to: rx.state)
            .disposed(by: disposeBag)        
    }
    
    private func handleFavorite(_ char: CharacterModel, _ cell: CharacterCollectionViewCell) {
        if self.viewModel.toggleFavorite(char) == true {
            cell.favorite.setImage(UIImage(named: "onFav"), for: .normal)
        } else {
            cell.favorite.setImage(UIImage(named: "offFav"), for: .normal)
        }
    }
    
    private func setupBindings() {
        
        containerView.collectionView.register(CharacterCollectionViewCell.self, forCellWithReuseIdentifier: "CharacterCollectionViewCell")
        
        characters.bind(to: containerView.collectionView.rx.items(
            cellIdentifier: "CharacterCollectionViewCell",
            cellType: CharacterCollectionViewCell.self)) { (_, char, cell) in
                
                cell.favoriteTap
                    .subscribe(onNext: { [weak self] _ in
                        self?.handleFavorite(char, cell)
                    }).disposed(by: cell.disposeBag)
                
                cell.name.text = "\"" + (char.name ?? "") + "\""
                let url = URL(string: char.imagePortrait ?? "")
                cell.thumbnail.kf.setImage(with: url)
                let image = char.favorite ? UIImage(named: "onFav") : UIImage(named: "offFav")
                cell.favorite.setImage(image, for: .normal)
                
        }.disposed(by: disposeBag)
        
        containerView.collectionView.rx.modelSelected(CharacterModel.self)
            .subscribe(onNext: { model in
                let event = FavoritesCoordinatorEvent.showDetail(model: model)
                do {
                    try self.parentCoordinator?.handle(event: event)
                } catch {
                    fatalError("Cant't open \(event)")
                }
            }).disposed(by: disposeBag)
                
        viewModel
            .characters
            .observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .bind(to: self.characters)
            .disposed(by: disposeBag)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if offsetY + .offset > contentHeight - scrollView.frame.size.height {
            viewModel.getFavorites()
                .bind(to: rx.state)
                .disposed(by: disposeBag)
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension FavoritesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellsInRow = 2
        
        guard let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout else {
            return CGSize.zero
        }
        
        let totalSpace = flowLayout.sectionInset.left
            + flowLayout.sectionInset.right
            + (flowLayout.minimumInteritemSpacing * CGFloat(cellsInRow - 1))
        
        let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(cellsInRow))
        
        return CGSize(width: size, height: Int(Double(size) * 1.68))
    }
}

// MARK: - RX Bindings

extension Reactive where Base: FavoritesViewController {
    
    var state: Binder<FavoritesViewState> {
        return Binder(base) { controller, state in
            switch state {
            case .success(let isEmpty):
                if isEmpty {
                    controller.containerView.collectionView.backgroundView = controller.emptyView
                } else {
                    controller.containerView.collectionView.backgroundView = UIView()
                }
            case .loading:
                if let count = try? controller.characters.value().count, count == 0 {
                    controller.containerView.collectionView.backgroundView = controller.loadingView
                }
            case .error:
                controller.characters.onNext([])
                controller.containerView.collectionView.backgroundView = controller.errorView
            }
            controller.view.setNeedsLayout()
        }
    }
}

private extension CGFloat {
    static let offset: CGFloat = 600
}
