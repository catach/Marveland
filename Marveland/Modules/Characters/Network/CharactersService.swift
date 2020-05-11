//
//  CharactersService.swift
//  Marveland
//
//  Created by Marcelo Catach on 08/05/20.
//  Copyright © 2020 Marcelo Catach. All rights reserved.
//

import RxSwift
import Moya
import Moya_ObjectMapper
import ObjectMapper

protocol CharactersServiceProtocol {
    func getCharacters(request: GetCharactersRequest) -> Observable<CharactersModel>
}

class CharactersService: CharactersServiceProtocol {
    private let provider: MoyaProvider<CharactersTargetType>

    func getCharacters(request: GetCharactersRequest) -> Observable<CharactersModel> {
        
        return provider.rx
            .request(.getCharacters(request))
            .mapObject(GetCharactersResponse.self)
            .map { CharactersModel(from: $0) }
            .asObservable()
    }
    
    required init(provider: MoyaProvider<CharactersTargetType>) {
        self.provider = provider
    }
}
