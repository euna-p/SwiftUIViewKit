//
//  AppDelegate.swift
//  SwiftUIViewKitSampleApp
//
//  Created by LONELiE on 2023/02/10.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
        
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.makeKeyAndVisible()
        self.window?.backgroundColor = .systemBackground
        
        let viewController = MainViewController()
        let navigationController = UINavigationController(rootViewController: viewController)
        self.window?.rootViewController = navigationController
        
        return true
    }
}

