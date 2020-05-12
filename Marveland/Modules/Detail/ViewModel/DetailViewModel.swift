//
//  DetailViewModel.swift
//  Marveland
//
//  Created by Marcelo Catach on 11/05/20.
//  Copyright © 2020 Marcelo Catach. All rights reserved.
//

import RxSwift
import Foundation

enum DetailErrorState {
    case unknown
}

enum DetailViewState {
    case success(DetailModel)
    case loading
    case error
}

protocol DetailViewModelType {
    init(service: DetailServiceProtocol)
    func getDetail(charId: String) -> Observable<DetailViewState>
}

class DetailViewModel: DetailViewModelType {
    
    private let service: DetailServiceProtocol
    public let detail: PublishSubject<DetailModel> = PublishSubject()
    
    required init(service: DetailServiceProtocol) {
        self.service = service
    }
    
    func getDetail(charId: String) -> Observable<DetailViewState> {
        
        let request = DetailRequest(
            charId: charId
        )
        
        return service.getDetail(request: request, charId: charId)
            .observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .map { model in
                return .success(model)
            }
            .catchError { error -> Observable<DetailViewState> in
                .error(error)
            }
            .startWith(.loading)
    }
}
