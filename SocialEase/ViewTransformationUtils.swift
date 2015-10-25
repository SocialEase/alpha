//
//  ViewTransformationUtils.swift
//  SocialEase
//
//  Created by Soumya on 10/25/15.
//  Copyright © 2015 Yuichi Kuroda. All rights reserved.
//

import Foundation
import UIKit

class ViewTransformationUtils {

    class func convertViewToCircle(myView: UIView, borderColor: UIColor, borderWidth: Int) {
        myView.layer.masksToBounds = false
        myView.layer.cornerRadius = myView.frame.size.height/2
        myView.clipsToBounds = true
        
        myView.layer.borderWidth = 1.0
        myView.layer.borderColor = borderColor.CGColor
    }

}