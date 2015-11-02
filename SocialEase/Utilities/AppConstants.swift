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
    static let Plan = UIStoryboard(name: "Plan", bundle: nil)
    static let ActivityDetails = UIStoryboard(name: "ActivityDetails", bundle: nil)

    // View controller identifiers
    static let CuisinesVCIndentifier = "CategoriesViewNavigationController"
    static let LoginVCIdentifier = "LoginViewController"
    static let LoginRegisterVCIdentifier = "RegisterViewController"
    static let SuggestionsNavVCIdentifier = "SuggestionsNavController"
    static let HomePageNavVCIdentifier = "HomePageNavViewController"
    static let HomePageVCIdentifier = "HomePageViewController" // This is identifier for page view controller that will be contained in HomeViewController
    static let PlanDisplayVCIdentifier = "PlanDisplayViewController"
    static let PlanTabedVCIdentifier = "PlanTabBarController"
    static let PlanInformationVCIdentifier = "PlanInformationViewController"
    static let PlanChatVCIdentifier = "PlanChatViewController"
    static let BusinessDetailVCIdentifier = "BusinessDetailsViewController"

    // segue identifier

}

enum BusinessDetailVCCellIdentifiers: String {
        case BusinessDetailViewCell, BusinessMapTableViewCell, BusinessAddressTableViewCell, BusinessPhoneTableViewCell
}


struct SocialEaseIcons {
    static let FontName = "socialease"
    enum Map: Character {
        case FilledSquare = "a"
        case CheckedSquare = "b"
        case EmptySquare = "c"
        case FilledCircle = "d"
        case EmptyCircle = "e"
        case DownArrowThick = "f"
        case Plus = "g"
        case DownArrowThin = "h"
        case EmptyStar = "i"
        case HalfFilledStar = "j"
        case FilledStar = "k"
        case FilledCircleRightArrow = "l"
        case Preferences = "m"
        case Phone = "n"
        case ThumDown = "o"
        case ThumbUp = "p"
    }
}
typealias SocialEaseIconsType = SocialEaseIcons.Map
