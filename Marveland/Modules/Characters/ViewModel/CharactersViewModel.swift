//
//  CharactersViewModel.swift
//  Marveland
//
//  Created by Marcelo Catach on 08/05/20.
//  Copyright © 2020 Marcelo Catach. All rights reserved.
//

import RxSwift
import Foundation

enum CharactersErrorState: Equatable {
    case unknown
}

enum CharactersViewState: Equatable {
    case success
    case loading
    case error
}

protocol CharactersViewModelType {
    init(service: CharactersServiceProtocol)
    func getCharacters() -> Observable<CharactersViewState>
}

class CharactersViewModel: CharactersViewModelType {
    
    private let service: CharactersServiceProtocol
    private var offset = 0
    public let characters: BehaviorSubject<[CharacterModel]> = BehaviorSubject(value: [])
    
    required init(service: CharactersServiceProtocol) {
        self.service = service
    }
    
    func getCharacters() -> Observable<CharactersViewState> {
        let request = GetCharactersRequest(
            orderBy: .name,
            limit: .offsetIncrement,
            offset: offset
        )
        offset += .offsetIncrement

        return service.getCharacters(request: request)
            .observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .map { model in
                do {
                    try self.characters.onNext(self.characters.value() + model.characters)
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
