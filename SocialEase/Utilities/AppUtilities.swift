//
//  AppUtilities.swift
//  SocialEase
//
//  Created by Amay Singhal on 10/21/15.
//  Copyright © 2015 Yuichi Kuroda. All rights reserved.
//

import UIKit
import CoreLocation

class AppUtilities: NSObject {

    static func updateTextAndTintColorForNavBar(navController: UINavigationController?, tintColor: UIColor?, textColor: UIColor?) {
        navController?.navigationBar.barTintColor = tintColor ?? UIColor.sea_primaryBackgroundColor()
        navController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: textColor ?? UIColor.darkGrayColor()]
    }

    static func getRatingsTextFromRating(rating: Double, forTotalRating totalRating: Int = 5) -> String {

        let fullStarCount = Int(floor(rating))
        let halfStarCount = rating % 1 > 0 ? 1 : 0
        let emptyStarCount = totalRating - Int(ceil(rating))

        return String(count: fullStarCount, repeatedValue: SocialEaseIconsType.FilledStar.rawValue) + String(count: halfStarCount, repeatedValue: SocialEaseIconsType.HalfFilledStar.rawValue) + String(count: emptyStarCount, repeatedValue: SocialEaseIconsType.EmptyStar.rawValue)
    }

    static func launchDirections(addressStrings: [String]) {
        if let escapedAddress = addressStrings.joinWithSeparator(" ").stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet()) {
            let appleMapsUrl = NSURL(string: "http://maps.apple.com/?daddr=\(escapedAddress)&dirflg=d&t=h")!

            if UIApplication.sharedApplication().canOpenURL(appleMapsUrl) {
                UIApplication.sharedApplication().openURL(appleMapsUrl)
            }
        }
    }

    static func getGreetingDisplayText(name: String?) -> String {
        return DateUtils.getDayGreeting(NSDate()) + " " + (name ?? "") + "!"
    }
}
