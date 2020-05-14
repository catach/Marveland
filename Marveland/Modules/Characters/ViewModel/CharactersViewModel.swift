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

enum CharactersViewState {
    case success(Bool)
    case loading
    case error
}

protocol CharactersViewModelType {
    init(service: CharactersServiceProtocol)
    func getCharacters(startingWith text: String?, startFromBeginning: Bool) -> Observable<CharactersViewState>
}

class CharactersViewModel: CharactersViewModelType {
    
    private let service: CharactersServiceProtocol
    private let favoriteManager = FavoriteManager()
    private var offset = 0
    private var oldText = ""
    public let characters: BehaviorSubject<[CharacterModel]> = BehaviorSubject(value: [])
    
    required init(service: CharactersServiceProtocol) {
        self.service = service
    }
            
    func getCharacters(startingWith text: String? = nil,
                       startFromBeginning: Bool = false) -> Observable<CharactersViewState> {
        if let text = text {
            if startFromBeginning || (oldText != text) {
                offset = 0
            }
            oldText = text
        }
        
        print("OFFSET: \(offset)")
        
        let request = GetCharactersRequest(
            orderBy: .name,
            limit: .offsetIncrement,
            offset: offset,
            nameStartsWith: text == "" ? nil : text
        )
        
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
                self.offset += model.characters.count
                return try self.characters.value().isEmpty ? .success(true) : .success(false)
        }
        .catchErrorJustReturn(.error)
        .startWith(.loading)
    }
}

extension Int {
    static let offsetIncrement = 10
}
