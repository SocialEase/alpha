//
//  AppConstants.swift
//  SocialEase
//
//  Created by Amay Singhal on 10/21/15.
//  Copyright © 2015 Yuichi Kuroda. All rights reserved.
//

import UIKit

struct AppConstants {
    static let AppName = "SocialEase"
}

struct Storyboard {

    // Story board instances
    static let Main = UIStoryboard(name: "Main", bundle: nil)
    static let Login = UIStoryboard(name: "Login", bundle: nil)
    static let Suggestions = UIStoryboard(name: "Suggestions", bundle: nil)
    static let Home = UIStoryboard(name: "Home", bundle: nil)

    // View controller identifiers
    static let LoginInitialVCIdentifier = "WelcomeViewController2"
    static let SuggestionsNavVCIdentifier = "SuggestionsNavController"
    static let HomePageNavVCIdentifier = "HomePageNavViewController"
    static let HomePageVCIdentifier = "HomePageViewController" // This is identifier for page view controller that will be contained in HomeViewController
    static let PlanDisplayVCIdentifier = "PlanDisplayViewController"

    // segue identifier

}