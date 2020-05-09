//
//  CoordinatorProtocol.swift
//  Marveland
//
//  Created by Marcelo Catach on 06/05/20.
//  Copyright © 2020 Marcelo Catach. All rights reserved.
//

import Foundation

public protocol AppEvent {}

public protocol CoordinatorProtocol: AnyObject, NSObjectProtocol {

    var parent: CoordinatorProtocol? { get set }
    var identifier: String { get }
    var handlers: [String: (AppEvent) -> Void] { get }

    func target<T: AppEvent>(forEvent event: T) -> CoordinatorProtocol?
    func handle<T: AppEvent>(event: T) throws
    func add<T: AppEvent>(eventType: T.Type, handler: @escaping (T) -> Void)
    func canHandle<T: AppEvent>(event: T) -> Bool

    func start(with completion: @escaping () -> Void)
    func stop(removingParentCoordinator: Bool, with completion: @escaping () -> Void)

    var childCoordinators: [String: CoordinatorProtocol] { get }

    func startChild(coordinator: CoordinatorProtocol, completion: @escaping () -> Void)
    func stopChild(coordinator: CoordinatorProtocol, completion: @escaping () -> Void)

}

public extension CoordinatorProtocol {

    var identifier: String {
        return "\(String(describing: type(of: self)))-\(self.hash)"
    }
}
