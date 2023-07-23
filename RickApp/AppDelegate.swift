//
//  AppDelegate.swift
//  lab04hw
//
//  Created by Никита Зорин on 27.06.2023.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let launchCount = UserDefaults.standard.integer(forKey: "LaunchCount")
        
        UserDefaults.standard.set(launchCount + 1, forKey: "LaunchCount")
        if (launchCount + 1) % 3 == 0 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.showAlert(with: "Nice work!", message: "You have launched the app \(launchCount + 1) times!")
            }
        }
        
        return true
    }

    
    func showAlert(with title: String, message: String) {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
            let window = windowScene.windows.first {
            
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            
            window.rootViewController?.present(alertController, animated: true, completion: nil)
        }
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

