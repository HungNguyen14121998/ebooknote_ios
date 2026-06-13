//
//  SceneDelegate.swift
//  EBookNote
//
//  Created by Nguyen Huu Hung on 7/19/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }

        window = UIWindow(windowScene: windowScene)
        
        // splash screen
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let myViewController = storyboard.instantiateViewController(withIdentifier: "SplashViewController") as! SplashViewController
        window?.rootViewController = myViewController
        window?.makeKeyAndVisible()
        
        handleLogin()
    }
    
}

// MARK: - Handle Login

extension SceneDelegate {
    
    func handleLogin() {
        let dataStoreAccessToken = DataStoreManager(key: UserDefaultsKey.kAccessToken)
        if let acccessToken = dataStoreAccessToken.getValue() as? String, acccessToken.count > 0 {
            APIClient.autoLogin(accessToken: acccessToken, completion: handleAutoLogin(response:error:))
        } else {
            goToLogin()
        }
    }
    
    private func handleAutoLogin(response: LoginResponseModel?, error: Error?) {
        if (error != nil) {
            goToLogin()
        } else {
            // go to Home
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let myViewController = storyboard.instantiateViewController(withIdentifier: "MainTabbarViewController") as! MainTabbarViewController
            let navController = UINavigationController(rootViewController: myViewController)
            
            window?.rootViewController = navController
            window?.makeKeyAndVisible()
        }
    }
    
    private func goToLogin() {
        // go to Login
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let myViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        let navController = UINavigationController(rootViewController: myViewController)
        
        window?.rootViewController = navController
        window?.makeKeyAndVisible()
    }
    
}

