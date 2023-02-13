//
//  SceneDelegate.swift
//  ToggleHomeTask
//
//  Created by Daniel Tischenko on 11.02.2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    private lazy var store: TimeEntriesStore = InMemoryTimeEntriesStore()

    private lazy var cacheTimeEntryUseCase = CacheTimeEntryUseCase(store: store)

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }

        window = UIWindow(windowScene: scene)
        window?.rootViewController = TimeTrackingUIComposer.timeTracking(onTimeEntryCreated: { [unowned self] timeEntry in
            cacheTimeEntryUseCase.save(timeEntry) { _ in }
        })
        window?.makeKeyAndVisible()
    }
}

