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
    
    func presentLogin() {
        let loginStoryboard = Storyboard.Login
        
        let viewController = loginStoryboard.instantiateViewControllerWithIdentifier(Storyboard.LoginInitialVCIdentifier)
        
        LoginViewController.completionCallback = { () -> () in
            self.presentGroupSelection()
        }
        CategoriesViewController.completionCallback = { () -> () in
            self.presentGroupSelection()
        }
        
        self.window!.rootViewController = viewController
        self.window!.makeKeyAndVisible()
    }
    
    func presentGroupSelection() {
        let viewController = GroupSelectionViewController()
        viewController.completionCallback = { (group: Group) -> () in
            self.presentSuggestions(group)
        }
        
        let navController: UINavigationController = UINavigationController(rootViewController: viewController)
        navController.navigationItem.title = AppConstants.AppName
        
        self.window!.rootViewController = navController
        self.window!.makeKeyAndVisible()
    }
    
    func presentSuggestions(group: Group) {
        if let rootViewControler = self.window.rootViewController as? UINavigationController {
            let suggestionsStoryboard = UIStoryboard(name: "Suggestions", bundle: nil)
            let viewController = suggestionsStoryboard.instantiateViewControllerWithIdentifier("SuggestionsViewController")

            rootViewControler.pushViewController(viewController, animated: true)
        }
    }
}