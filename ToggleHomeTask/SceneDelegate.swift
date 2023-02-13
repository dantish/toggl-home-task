//
//  SceneDelegate.swift
//  ToggleHomeTask
//
//  Created by Daniel Tischenko on 11.02.2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }

        window = UIWindow(windowScene: scene)
        window?.rootViewController = TimeTrackingUIComposer.timeTracking()
        window?.makeKeyAndVisible()
    }
}

