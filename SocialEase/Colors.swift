//
//  Colors.swift
//  SocialEase
//
//  Created by Yuichi Kuroda on 10/17/15.
//  Copyright © 2015 Yuichi Kuroda. All rights reserved.
//

import UIKit

extension UIColor {
    static func sea_primaryColor() -> UIColor { // #0072bb
        return UIColor(red: 0.0/255.0, green: 114.0/255.0, blue: 187.0/255.0, alpha: 1.0)
    }
    static func sea_primaryBackgroundColor() -> UIColor {
        return UIColor.whiteColor()
    }
    static func sea_primaryLightTextColor() -> UIColor {
        return UIColor.whiteColor()
    }
    static func sea_primaryHighlightColor() -> UIColor { // #bb4900
        return UIColor(red: 187.0/255.0, green: 73.0/255.0, blue: 0.0/255.0, alpha: 1.0)
    }
    static func sea_primaryShadeColor() -> UIColor { // #e2f4ff
        return UIColor(red: 226.0/255.0, green: 244.0/255.0, blue: 255.0/255.0, alpha: 1.0)
    }

    static func sea_secondaryHintColor() -> UIColor {
        return UIColor(red: 169.0/255.0, green: 169.0/255.0, blue: 174.0/255.0, alpha: 1.0)
    }
    static func sea_secondarySelectedColor() -> UIColor {
        return UIColor(red: 0.0/255.0, green: 187.0/255.0, blue: 73.0/255.0, alpha: 1.0)
    }

    class func sea_primaryLabelColor() -> UIColor {
        return UIColor.darkGrayColor()
    }
    
    class func sea_lightLabelColor() -> UIColor {
        return UIColor.darkGrayColor()
    }

    class func sea_unselectedButtonColor() -> UIColor {
        return sea_primaryLightTextColor()
        //return UIColor(red: 139/255, green: 139/255, blue: 139/255, alpha: 1)
    }

    class func sea_selectedButtonColor() -> UIColor {
        return UIColor.darkGrayColor()
    }
}
