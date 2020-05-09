//
//  AppDelegate.swift
//  Marveland
//
//  Created by Marcelo Catach on 06/05/20.
//  Copyright © 2020 Marcelo Catach. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var rootCoordinator: AppCoordinator?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let window = UIWindow()
        self.window = window
        self.rootCoordinator = AppCoordinator(window: window)
        self.rootCoordinator?.start()
        do {
            try self.rootCoordinator?.handle(event: AppCoordinatorEvent.openHome)
        } catch {
            if case let AppEventError.eventNotHandled(event) = error {
                fatalError("event not handled: [\(String(reflecting: type(of: event)))]")
            }
        }
        return true
    }
}
