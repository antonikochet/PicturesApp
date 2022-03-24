//
//  AppDelegate.swift
//  PicturesApp
//
//  Created by Антон Кочетков on 14.03.2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    // MARK: - Application lifecycle

    var window: UIWindow?   // For iOS 12

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
            
        let viewController = AppAssembly.assemblyList()
        let navigationVC = UINavigationController(rootViewController: viewController)
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = navigationVC
        self.window?.makeKeyAndVisible()
        
        return true
    }

    func applicationWillEnterForeground(_ application: UIApplication) {

    }

    // MARK: UISceneSession Lifecycle

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}

