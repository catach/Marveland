//
//  DetailService.swift
//  Marveland
//
//  Created by Marcelo Catach on 11/05/20.
//  Copyright © 2020 Marcelo Catach. All rights reserved.
//

import RxSwift
import Moya
import Moya_ObjectMapper
import ObjectMapper

protocol DetailServiceProtocol {
    func getDetail(request: DetailRequest, charId: String) -> Observable<DetailModel>
}

class DetailService: DetailServiceProtocol {
    private let provider: MoyaProvider<DetailTargetType>

    func getDetail(request: DetailRequest, charId: String) -> Observable<DetailModel> {
        
        return provider.rx
            .request(.getDetail(request, charId))
            .mapObject(DetailResponse.self)
            .map { DetailModel(from: $0) }
            .asObservable()
    }
    
    required init(provider: MoyaProvider<DetailTargetType>) {
        self.provider = provider
    }
}
