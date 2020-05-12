//
//  DetailViewController.swift
//  Marveland
//
//  Created by Marcelo Catach on 11/05/20.
//  Copyright © 2020 Marcelo Catach. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Moya
import Kingfisher

class DetailViewController: UIViewController {
    private let containerView = CharactersView()
    private let disposeBag = DisposeBag()
    private var viewModel: DetailViewModel?
    private var charId: String
    
    init(for chardId: String) {
        self.charId = chardId
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = containerView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        let provider = MoyaProvider<DetailTargetType>(plugins: [NetworkLoggerPlugin()])
        let service = DetailService(provider: provider)
        
        self.viewModel = DetailViewModel(service: service)
        
        setupBindings()        
    }
    
    private func setupBindings() {
    }
}

// MARK: - RX Bindings

extension Reactive where Base: DetailViewController {

    var state: Binder<DetailViewState> {
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
