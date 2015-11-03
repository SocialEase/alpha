//
//  OtherPreference.swift
//  SocialEase
//
//  Created by Uday on 10/23/15.
//  Copyright © 2015 udaymitra. All rights reserved.
//

import UIKit

class OtherPreference: NSObject {
    var displayString : String!
    var isSelected : Bool
    
    convenience init(displayString : String) {
        self.init(displayString : displayString, isSelected : false)
    }
    
    init(displayString : String, isSelected : Bool) {
        self.displayString = displayString
        self.isSelected = isSelected
    }
    
    private class func getDistancePrefrences() -> [OtherPreference] {
        return [
            OtherPreference(displayString: "1 miles"),
            OtherPreference(displayString: "5 miles"),
            OtherPreference(displayString: "10 miles"),
            OtherPreference(displayString: "20 miles"),
            OtherPreference(displayString: "50 miles")
        ]
    }
    
    private class func getTryNewPrefrences() -> [OtherPreference] {
        return [
            OtherPreference(displayString: "Quite often"),
            OtherPreference(displayString: "Sometimes"),
            OtherPreference(displayString: "Never")
        ]
    }
    
    class func getAllPreferences() -> [(String, [OtherPreference])] {
        return [
            ("How far do you like to travel?", getDistancePrefrences()),
            ("Try something new?", getTryNewPrefrences())
        ]
    }
}
