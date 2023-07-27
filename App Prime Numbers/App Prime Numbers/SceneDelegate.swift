//
//  SceneDelegate.swift
//  App Prime Numbers
//
//  Created by Karen Oliveira on 21/11/22.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        self.window = UIWindow(windowScene: windowScene)
        let presenter = Presenter()
        let viewController = ViewController(presenter: presenter)
        presenter.view = viewController
        self.window?.rootViewController = viewController
        window?.makeKeyAndVisible()
    }
}

