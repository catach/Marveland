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
    private var characters: PublishSubject<[CharacterModel]> = PublishSubject()
    private var viewModel: CharactersViewModel?
   
    override func loadView() {
        view = containerView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        let provider = MoyaProvider<CharactersTargetType>(plugins: [NetworkLoggerPlugin()])
        let service = CharactersService(provider: provider)
        
        self.viewModel = CharactersViewModel(service: service)
        
        containerView.collectionView?.delegate = self
        setupBindings()
        viewModel?.getCharacters()
            .bind(to: rx.state)
            .disposed(by: disposeBag)
    }
    
    private func setupBindings() {
        
        if let collectionView = containerView.collectionView {
            collectionView.register(CharacterCollectionViewCell.self, forCellWithReuseIdentifier: "CharacterCollectionViewCell")

            characters.bind(to: collectionView.rx.items(
                cellIdentifier: "CharacterCollectionViewCell",
                cellType: CharacterCollectionViewCell.self)) { (_, char, cell) in
                    cell.name.text = "\"" + (char.name ?? "") + "\""
                    let url = URL(string: char.thumbnail ?? "")
                    cell.thumbnail.kf.setImage(with: url)
            }.disposed(by: disposeBag)
            
            collectionView.rx.willDisplayCell
                .subscribe(onNext: ({ (cell, _) in
//                    cell.alpha = 0
//                    UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
//                        cell.alpha = 1
//                    }, completion: nil)
                })).disposed(by: disposeBag)
        }
        
        viewModel?
            .characters
            .observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .bind(to: self.characters)
            .disposed(by: disposeBag)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if offsetY + 600 > contentHeight - scrollView.frame.size.height {
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

extension CharactersViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       print("User tapped on item \(indexPath.row)")
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
