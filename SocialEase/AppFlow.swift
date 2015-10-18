//
//  AppFlow.swift
//  SocialEase
//
//  Created by Yuichi Kuroda on 10/17/15.
//  Copyright © 2015 Yuichi Kuroda. All rights reserved.
//

import UIKit

class AppFlow: NSObject {
    var window: UIWindow!
    
    override init() {
        if let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate {
            window = appDelegate.window!
        }
    }
    
    func presentRoot() {
        let viewController = ViewController()
        viewController.completionCallback = { () -> () in
            self.presentLogin()
        }
        
        let navController: UINavigationController = UINavigationController(rootViewController: viewController)
        navController.navigationItem.title = "Social Ease"
        
        self.window!.rootViewController = navController
        self.window!.makeKeyAndVisible()
        
    }
    
    func presentLogin() {
        if let rootViewController = self.window.rootViewController as? UINavigationController {
            let viewController = LoginViewController()
            viewController.completionCallback = { () -> () in
                self.presentGroupSelection()
            }
            
            rootViewController.pushViewController(viewController, animated: true)
        }
    }
    
    func presentGroupSelection() {
        if let rootViewControler = self.window.rootViewController as? UINavigationController {
            let viewController = GroupSelectionViewController()
            viewController.completionCallback = { () -> () in
                self.presentSuggestions()
            }
            
            rootViewControler.pushViewController(viewController, animated: true)
            
        }
    }
    
    func presentSuggestions() {
        if let rootViewControler = self.window.rootViewController as? UINavigationController {
            let viewController = SuggestionsViewController()
            viewController.completionCallback = { () -> () in
                // TODO: Next view
            }
            
            rootViewControler.pushViewController(viewController, animated: true)
        }
    }
}