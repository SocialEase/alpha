//
//  UserPreferences.swift
//  SocialEase
//
//  Created by Uday on 10/19/15.
//  Copyright © 2015 udaymitra. All rights reserved.
//

import UIKit

class UserPreferences: NSObject {
    var favoriteCuisines: [String]!
    
    init(favoriteCuisines: [String]!) {
        self.favoriteCuisines = favoriteCuisines
    }

    func encodedString() -> String {
        return favoriteCuisines.joinWithSeparator(",")
    }
    
    class func getUserPreferences(encodedString: String) -> UserPreferences {
        let favoriteCuisines = encodedString.componentsSeparatedByString(",")
        return UserPreferences(favoriteCuisines: favoriteCuisines)
    }
}
