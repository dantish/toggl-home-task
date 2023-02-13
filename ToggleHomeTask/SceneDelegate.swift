//
//  SceneDelegate.swift
//  ToggleHomeTask
//
//  Created by Daniel Tischenko on 11.02.2023.
//

import UIKit
import Combine

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    private lazy var store: TimeEntriesStore = InMemoryTimeEntriesStore()

    private lazy var cacheTimeEntryUseCase = CacheTimeEntryUseCase(store: store)

    private lazy var loadTimeEntriesFromCacheUseCase = LoadTimeEntriesFromCacheUseCase(store: store)

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }

        window = UIWindow(windowScene: scene)

        let timeTrackingVC = TimeTrackingUIComposer.timeTracking(onTimeEntryCreated: { [unowned self] timeEntry in
            cacheTimeEntryUseCase.save(timeEntry) { _ in }
        })
        timeTrackingVC.title = "Track"

        let timeEntriesVC = TimeEntriesUIComposer.timeEntriesComposedWith(timeEntriesLoader: makeTimeEntriesLoader)
        timeEntriesVC.title = "List"

        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [timeTrackingVC, timeEntriesVC]
        window?.rootViewController = tabBarController

        window?.makeKeyAndVisible()
    }

    private func makeTimeEntriesLoader() -> AnyPublisher<[TimeEntry], Error> {
        Deferred {
            Future(self.loadTimeEntriesFromCacheUseCase.load)
        }
        .eraseToAnyPublisher()
    }
}

