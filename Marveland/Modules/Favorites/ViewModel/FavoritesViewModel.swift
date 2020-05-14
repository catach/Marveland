//
//  FavoritesViewModel.swift
//  Marveland
//
//  Created by Marcelo Catach on 13/05/20.
//  Copyright © 2020 Marcelo Catach. All rights reserved.
//

import Foundation
import RealmSwift
import RxSwift

enum FavoritesViewState {
    case success
    case loading
    case error
}

protocol FavoritesViewModelType {
    func getFavorites() -> Observable<FavoritesViewState>
    func toggleFavorite(_ model: CharacterModel?) -> Bool
}

class FavoritesViewModel {
    
    var characters: BehaviorSubject<[CharacterModel]> = BehaviorSubject(value: [])
    private let favoriteManager = FavoriteManager()
    
    func toggleFavorite(_ model: CharacterModel?) -> Bool {
        return favoriteManager.toggleFavorite(model)
    }
    
    func getFavorites() -> Observable<FavoritesViewState> {
        guard let realm = try? Realm() else { return Observable.just(.error) }
        
        return Observable.create { (observer) -> Disposable in
            self.characters.onNext(Array(realm.objects(CharacterModel.self)
                .filter("favorite = 1")))
            observer.onNext(.success)
            return Disposables.create()
        }.startWith(.loading)
    }
}
