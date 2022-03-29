//
//  AppDelegate.swift
//  Meter Card and Smart Parking Meter
//
//  Created by Mohammed Skaik on 07/03/2022.
//

import UIKit
import IQKeyboardManagerSwift
import GoogleMaps
//import GooglePlaces

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    static var shared = UIApplication.shared.delegate as? AppDelegate

    var rootNavigationController: MainNavigationController?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        IQKeyboardManager.shared.enable = true
//        IQKeyboardManager.shared.enableDebugging = true
        IQKeyboardManager.shared.layoutIfNeededOnUpdate = true

        GMSServices.provideAPIKey("AIzaSyDHfiMj-qKhR14M5zTnqjt3wUeMMTlmwjc")
//        GMSPlacesClient.provideAPIKey("AIzaSyDHfiMj-qKhR14M5zTnqjt3wUeMMTlmwjc")

        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

