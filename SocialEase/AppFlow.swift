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
        
        let viewController = loginStoryboard.instantiateViewControllerWithIdentifier(Storyboard.LoginVCIdentifier)
        
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
        // TODO: kevin - uncomment
        //let viewController = GroupSelectionViewController()
        //viewController.completionCallback = { (group: Group) -> () in
            self.presentSuggestions()
        //}
        
//        let navController: UINavigationController = UINavigationController(rootViewController: viewController)
//        navController.navigationItem.title = AppConstants.AppName
//        
//        self.window!.rootViewController = navController
//        self.window!.makeKeyAndVisible()
    }
    
    func presentBusinessDetail() {
        if let rootViewControler = self.window.rootViewController as? UINavigationController {
            let viewController = Storyboard.BusinessDetail.instantiateViewControllerWithIdentifier("BusinessDetailViewController")
            
            rootViewControler.pushViewController(viewController, animated: true)
        }
    }
    
    func presentSuggestions(group: Group) {
        if let rootViewControler = self.window.rootViewController as? UINavigationController {
            let viewController = Storyboard.Suggestions.instantiateViewControllerWithIdentifier("SuggestionsViewController")

            rootViewControler.pushViewController(viewController, animated: true)
        }
    }
    
    func presentSuggestions() {
        if let rootViewControler = self.window.rootViewController as? UINavigationController {
            let viewController = Storyboard.Suggestions.instantiateViewControllerWithIdentifier("SuggestionsViewController")
            
            rootViewControler.pushViewController(viewController, animated: true)
        }
    }

    func presentHomePageViewController() {
        AppFlow.presentHomePageViewControllerUsingWindow(self.window!)
    }
    
    class func presentHomePageViewControllerUsingWindow(window : UIWindow) {
        if let homePageNavVC = Storyboard.Home.instantiateViewControllerWithIdentifier(Storyboard.HomePageNavVCIdentifier) as? UINavigationController {
            window.rootViewController = homePageNavVC
            window.makeKeyAndVisible()
        }
    }

    func presentPlanViewController(plan: Plan) {
        if let rootViewControler = self.window.rootViewController as? UINavigationController, let planTabBarVC = Storyboard.Plan.instantiateViewControllerWithIdentifier(Storyboard.PlanTabedVCIdentifier) as? UITabBarController {
            if let tabViewControllers = planTabBarVC.viewControllers {
                for vc in tabViewControllers {
                    if let planVCContext = vc as? PlanViewControllerContext  {
                        planVCContext.plan = plan
                    }
                }
            }
            rootViewControler.pushViewController(planTabBarVC, animated: true)
        }
    }
}