//
//  AppUtilities.swift
//  SocialEase
//
//  Created by Amay Singhal on 10/21/15.
//  Copyright © 2015 Yuichi Kuroda. All rights reserved.
//

import UIKit

class AppUtilities: NSObject {

    static func updateTextAndTintColorForNavBar(navController: UINavigationController?, tintColor: UIColor?, textColor: UIColor?) {
        navController?.navigationBar.barTintColor = tintColor ?? UIColor.sea_primaryBackgroundColor()
        navController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: textColor ?? UIColor.darkGrayColor()]
    }
}
