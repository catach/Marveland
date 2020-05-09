//
//  Coordinator.swift
//  Marveland
//
//  Created by Marcelo Catach on 06/05/20.
//  Copyright © 2020 Marcelo Catach. All rights reserved.
//

import UIKit

public enum AppEventError: Error {
    case eventNotHandled(AppEvent)
}

open class Coordinator: NSObject, CoordinatorProtocol {

    open var parent: CoordinatorProtocol?
    open var childCoordinators: [String: CoordinatorProtocol] = [:]
    private(set) public var handlers: [String: (AppEvent) -> Void] = [:]

    open weak var rootViewController: UIViewController?

    public init(rootViewController: UIViewController?) {
        self.rootViewController = rootViewController
    }

    open func start(with completion: @escaping () -> Void = {}) {
        rootViewController?.parentCoordinator = self
        completion()
    }

    open func stop(removingParentCoordinator: Bool = false, with completion: @escaping () -> Void = {}) {
        if removingParentCoordinator {
            rootViewController?.parentCoordinator = nil
        }
        completion()
    }

    open func startChild(coordinator: CoordinatorProtocol, completion: @escaping () -> Void = {}) {
        childCoordinators[coordinator.identifier] = coordinator
        coordinator.parent = self
        coordinator.start(with: completion)
    }

    open func stopChild(coordinator: CoordinatorProtocol, completion: @escaping () -> Void = {}) {
        coordinator.parent = nil
        coordinator.stop(removingParentCoordinator: false) { [weak self] in
            self?.childCoordinators.removeValue(forKey: coordinator.identifier)
            completion()
        }
    }

    final public func add<T: AppEvent>(eventType: T.Type, handler: @escaping (T) -> Void) {
        handlers[String(reflecting: eventType)] = { event in
            guard let realEvent = event as? T else { return }
            handler(realEvent)
        }
    }

    final public func handle<T: AppEvent>(event: T) throws {
        let target = self.target(forEvent: event)
        guard let handler = target?.handlers[String(reflecting: type(of: event))] else {
            throw AppEventError.eventNotHandled(event)
        }
        handler(event)
    }

    final public func canHandle<T: AppEvent>(event: T) -> Bool {
        return handlers[String(reflecting: type(of: event))] != nil
    }

    open func target<T: AppEvent>(forEvent event: T) -> CoordinatorProtocol? {
        guard self.canHandle(event: event) != true else { return self }
        var next = self.parent
        while next?.canHandle(event: event) == false {
            next = next?.parent
        }
        return next
    }

    open func handleShow(viewController: UIViewController) {
        guard let rootViewController = self.rootViewController else {
            fatalError("\(self.classForCoder) must contain a rootViewController")
        }

        switch rootViewController {
        case let navigationController as UINavigationController:
            navigationController.pushViewController(viewController, animated: true)
        default:
            rootViewController.present(viewController, animated: true, completion: nil)
        }
    }

}
