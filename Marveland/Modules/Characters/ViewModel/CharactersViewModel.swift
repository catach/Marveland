//
//  CharactersViewModel.swift
//  Marveland
//
//  Created by Marcelo Catach on 08/05/20.
//  Copyright © 2020 Marcelo Catach. All rights reserved.
//

import RxSwift
import Foundation
import RealmSwift

enum CharactersErrorState {
    case unknown
}

enum CharactersViewState {
    case success
    case loading
    case error
}

protocol CharactersViewModelType {
    init(service: CharactersServiceProtocol)
    func getCharacters(startingWith text: String?, startFromBeginning: Bool) -> Observable<CharactersViewState>
    func toggleFavorite(_ model: CharacterModel?) -> Bool
}

class CharactersViewModel: CharactersViewModelType {
    
    private let service: CharactersServiceProtocol
    private var offset = 0
    public let characters: BehaviorSubject<[CharacterModel]> = BehaviorSubject(value: [])
    
    required init(service: CharactersServiceProtocol) {
        self.service = service
    }
    
    func toggleFavorite(_ model: CharacterModel?) -> Bool {
        guard let realm = try? Realm() else { return false }
            
        guard let model = model else { return false }
                
        let character = realm.object(ofType: CharacterModel.self, forPrimaryKey: model.charId)
        
        if character == nil {
            try? realm.write {
                model.favorite = true
                realm.add(model, update: .all)
            }
            return true
        } else {
            try? realm.write {
                model.favorite = !model.favorite
            }
            return model.favorite
        }
    }
    
    func getCharacters(startingWith text: String? = nil,
                       startFromBeginning: Bool = false) -> Observable<CharactersViewState> {
        var startFromBeginning = startFromBeginning
        
        if let text = text {
            if text.count == 0 {
                startFromBeginning = true
            } else if text.count < 3 {
                return Observable.empty()
            }
        }

        if startFromBeginning {
            offset = 0
        }
        
        let request = GetCharactersRequest(
            orderBy: .name,
            limit: .offsetIncrement,
            offset: offset,
            nameStartsWith: text == "" ? nil : text
        )
        offset += .offsetIncrement
        
        return service.getCharacters(request: request)
            .observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .map { model in
                do {
                    if startFromBeginning {
                        self.characters.onNext(model.characters)
                    } else {
                        try self.characters.onNext(self.characters.value() + model.characters)
                    }
                } catch {
                    print(error)
                }
                return .success
        }
        .catchError { error -> Observable<CharactersViewState> in
            .error(error)
        }
        .startWith(.loading)
    }
}

extension Int {
    static let offsetIncrement = 10
}
