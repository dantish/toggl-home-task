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

    private lazy var store: TimeEntriesStore = CodableTimeEntriesStore()

    private lazy var cacheTimeEntryUseCase = CacheTimeEntryUseCase(store: store)

    private lazy var loadTimeEntriesFromCacheUseCase = LoadTimeEntriesFromCacheUseCase(store: store)

    private lazy var removeTimeEntryFromCacheUseCase = RemoveTimeEntryFromCacheUseCase(store: store)

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }

        window = UIWindow(windowScene: scene)

        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [makeTimeTrackingVC(), makeTimeEntriesVC()]
        window?.rootViewController = tabBarController

        window?.makeKeyAndVisible()
    }

    private func makeTimeTrackingVC() -> TimeTrackingViewController {
        let timeTrackingVC = TimeTrackingUIComposer.timeTracking(onTimeEntryCreated: makeOnTimeEntryCreated())
        timeTrackingVC.title = "Track"
        return timeTrackingVC
    }

    private func makeTimeEntriesVC() -> TimeEntriesViewController {
        let timeEntriesVC = TimeEntriesUIComposer.timeEntriesComposedWith(
            timeEntriesLoader: makeTimeEntriesLoader,
            onTimeEntryRemoved: makeOnTimeEntryRemoved()
        )
        timeEntriesVC.title = "List"
        return timeEntriesVC
    }

    private func makeOnTimeEntryCreated() -> (TimeEntry) -> Void {
        return { [unowned self] timeEntry in
            cacheTimeEntryUseCase.save(timeEntry) { _ in }
        }
    }

    private func makeOnTimeEntryRemoved() -> (TimeEntry) -> Void {
        return { [unowned self] timeEntry in
            removeTimeEntryFromCacheUseCase.remove(timeEntry) { _ in }
        }
    }

    private func makeTimeEntriesLoader() -> AnyPublisher<[TimeEntry], Error> {
        Deferred {
            Future(self.loadTimeEntriesFromCacheUseCase.load)
        }
        .eraseToAnyPublisher()
    }
}

