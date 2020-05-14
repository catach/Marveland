//
//  CharactersViewController.swift
//  Marveland
//
//  Created by Marcelo Catach on 07/05/20.
//  Copyright © 2020 Marcelo Catach. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Moya
import Kingfisher

class CharactersViewController: UIViewController {
    private let containerView = CharactersView()
    private let disposeBag = DisposeBag()
    private var characters: BehaviorSubject<[CharacterModel]> = BehaviorSubject(value: [])
    private var viewModel: CharactersViewModel?
    private let favoriteManager = FavoriteManager()
    
    override func loadView() {
        view = containerView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let provider = MoyaProvider<CharactersTargetType>(plugins: [NetworkLoggerPlugin()])
        let service = CharactersService(provider: provider)
        
        self.viewModel = CharactersViewModel(service: service)
        
        containerView.collectionView.delegate = self
        containerView.searchBar.delegate = self
        
        setupBindings()
        
        viewModel?.getCharacters()
            .bind(to: rx.state)
            .disposed(by: disposeBag)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        containerView.collectionView.reloadData()
    }
    
    private func handleFavorite(_ char: CharacterModel, _ cell: CharacterCollectionViewCell) {
        if favoriteManager.toggleFavorite(char) == true {
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
                let image = self.favoriteManager.isFavorite(char.charId) ? UIImage(named: "onFav") : UIImage(named: "offFav")
                cell.favorite.setImage(image, for: .normal)

        }.disposed(by: disposeBag)
        
        containerView.collectionView.rx.modelSelected(CharacterModel.self)
            .subscribe(onNext: { model in
                let event = CharactersCoordinatorEvent.showDetail(model: model)
                do {
                    try self.parentCoordinator?.handle(event: event)
                } catch {
                    fatalError("Cant't open \(event)")
                }
            }).disposed(by: disposeBag)
          
        viewModel?
            .characters
            .observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .bind(to: self.characters)
            .disposed(by: disposeBag)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if offsetY + .offset > contentHeight - scrollView.frame.size.height {
            viewModel?.getCharacters()
                .bind(to: rx.state)
                .disposed(by: disposeBag)
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension CharactersViewController: UICollectionViewDelegateFlowLayout {
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

// MARK: - Search Bar delegate

extension CharactersViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == "" {
           searchBar.perform(#selector(self.resignFirstResponder), with: nil, afterDelay: 0.1)
        }
        
        viewModel?.getCharacters(startingWith: searchBar.text, startFromBeginning: true)
            .bind(to: rx.state)
            .disposed(by: disposeBag)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

// MARK: - RX Bindings

extension Reactive where Base: CharactersViewController {
    
    var state: Binder<CharactersViewState> {
        return Binder(base) { _, state in
            switch state {
            case .success:
                break
            case .loading:
                break
            case .error:
                break
            }
        }
    }
}

private extension CGFloat {
    static let offset: CGFloat = 600
}
