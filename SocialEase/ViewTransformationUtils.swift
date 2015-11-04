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

    static let BlurViewTag = 1000

    class func convertViewToCircle(myView: UIView, borderColor: UIColor, borderWidth: Int) {
        roundEdges(myView, cornerRadius: myView.frame.size.height/2, borderColor: borderColor, borderWidth: borderWidth)
    }
    
    class func roundEdges(myView: UIView, cornerRadius: CGFloat, borderColor: UIColor, borderWidth: Int) {
        myView.layer.masksToBounds = false
        myView.layer.cornerRadius = cornerRadius
        myView.clipsToBounds = true
        
        myView.layer.borderWidth = CGFloat(borderWidth)
        myView.layer.borderColor = borderColor.CGColor
    }

    static func addBlurToView(view: UIView, frame: CGRect, style: UIBlurEffectStyle = .ExtraLight) {
        let blurEffect: UIBlurEffect = UIBlurEffect(style: style)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.tag = BlurViewTag
        blurView.frame = frame

        // check if blur view is already added at index 0 by looking at view tag
        // remove is required so that multiple blur views are not added to view
        if view.subviews.count > 0 && view.subviews[0].tag == BlurViewTag {
            view.subviews[0].removeFromSuperview()
        }
        view.insertSubview(blurView, atIndex: 0)
    }
}