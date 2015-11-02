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
    
    
    func pushActivityDetailsView(activity: Activity) {
        if let rootViewControler = self.window.rootViewController as? UINavigationController, let activityDetailsVC = Storyboard.ActivityDetails.instantiateViewControllerWithIdentifier(Storyboard.BusinessDetailVCIdentifier) as? BusinessDetailsViewController {
            activityDetailsVC.activity = activity
            rootViewControler.pushViewController(activityDetailsVC, animated: true)
        }
    }

    func presentGroupSelection() {
        let viewController = GroupSelectionViewController()
        viewController.completionCallback = { (group: UserGroup) -> () in
            self.pushSuggestions(group)
        }
        
        let navController: UINavigationController = UINavigationController(rootViewController: viewController)
        navController.navigationItem.title = AppConstants.AppName
        
        self.window!.rootViewController?.presentViewController(navController, animated: true, completion: nil)
        self.window!.makeKeyAndVisible()
    }

    func pushSuggestions(group: UserGroup?) {
        if let navController = self.window.rootViewController?.presentedViewController as? UINavigationController {
            let suggestionsViewController = Storyboard.Suggestions.instantiateViewControllerWithIdentifier("SuggestionsViewController") as! SuggestionsViewController

            // We should assume that we have a group selected here
            // Not sure why the signature of this method accepts a optional
            suggestionsViewController.group = group!

            navController.pushViewController(suggestionsViewController, animated: true)
        }
    }

    func presentPlanViewControllerByFetchingPlanId(planId: String) {
        UserPlans.fetchCurrentUserPlanForPlanId(planId, usingCache: false) { (plan: Plan?, error: NSError?) -> () in
            self.presentHomePageViewController()
            if let plan = plan {
                self.pushPlanViewController(plan)
            }
        }
    }

    func presentHomePageViewController() {
        if let homePageNavVC = Storyboard.Home.instantiateViewControllerWithIdentifier(Storyboard.HomePageNavVCIdentifier) as? UINavigationController {
            window.rootViewController = homePageNavVC
            window.makeKeyAndVisible()
        }
    }
    
    func pushPlanViewController(plan: Plan) {
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