//
//  SceneDelegate.swift
//  TransationWidget
//
//  Created by Pheayuit.Yen    on 3/2/25.
//

import UIKit
import BackgroundTasks
import WidgetKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = ViewController()
        window?.makeKeyAndVisible()
        
        // Handle any URLs that were passed on launch
        if let urlContext = connectionOptions.urlContexts.first {
            handleURL(urlContext.url)
        }
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let urlContext = URLContexts.first else { return }
        handleURL(urlContext.url)
    }
    
    private func handleURL(_ url: URL) {
        print("Received URL: \(url)")
        
        guard let scheme = url.scheme, scheme == "myapp" else {
            print("Invalid URL scheme: \(url.scheme ?? "nil")")
            return
        }
        
        guard let host = url.host else {
            print("No host found in URL")
            return
        }
        
        switch host {
        case "profile":
            let id = url.lastPathComponent
            print("Handling profile with ID: \(id)")
            // Navigate to profile
            // Example: navigationController?.pushViewController(ProfileViewController(id: id), animated: true)
            
        case "PostSummaryVC":
            let postTitle = url.lastPathComponent.removingPercentEncoding
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.navigateToPostDetailView(withTitle: postTitle ?? "")
            }
        case "ShowMyQRVC":
            let title = url.lastPathComponent.removingPercentEncoding
            // Ensure the window is set up
            guard let window = window else { return }
            
            // Get the root view controller
            let rootViewController = window.rootViewController
            
            let viewController = ShowMyQRVC()
            
            
            if let firstComponent = title?.components(separatedBy: "-").first, let totalAmount = Double(firstComponent) {
                print("Total Amount: \(totalAmount)")
                let textPart = title?.contains("-") == true ? title?.split(separator: "-")[1] : "Empty"
                print("My Title: \(textPart ?? "")")
                viewController.myQR = title
                
            }
            //        viewController.modalTransitionStyle = .crossDissolve
            //        viewController.modalPresentationStyle = .fullScreen
            rootViewController?.present(viewController, animated: true, completion: nil)
        case "product":
            
            if let components = URLComponents(url: url, resolvingAgainstBaseURL: true),
               let queryItems = components.queryItems {
                // Parse query parameters
                for item in queryItems {
                    print("Query parameter: \(item.name) = \(item.value ?? "nil")")
                }
            }
            // Handle product navigation
            
        default:
            print("Unknown host: \(host)")
        }
    }
    
    func navigateToPostDetailView(withTitle title: String?) {
        // Ensure the window is set up
        guard let window = window else { return }
        
        // Get the root view controller
        let rootViewController = window.rootViewController
        
        let viewController = PostSummaryVC()
        
        
        if let firstComponent = title?.components(separatedBy: "-").first, let totalAmount = Double(firstComponent) {
            print("Total Amount: \(totalAmount)")
            let textPart = title?.contains("-") == true ? title?.split(separator: "-")[1] : "Empty"
            print("My Title: \(textPart ?? "")")
            viewController.postTitle = "\(textPart ?? "")" // Pass data to the view controller
            viewController.totalAmount = totalAmount
            
        }
        //        viewController.modalTransitionStyle = .crossDissolve
        //        viewController.modalPresentationStyle = .fullScreen
        rootViewController?.present(viewController, animated: true, completion: nil)
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
    
    
}

