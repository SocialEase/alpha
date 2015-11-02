//
//  AppExtensions.swift
//  SocialEaseSuggestionsWorkflow
//
//  Created by Amay Singhal on 10/18/15.
//  Copyright © 2015 ple. All rights reserved.
//

import Foundation
import UIKit

enum BorderPosition {
    case Top, Bottom, Left
}

extension UIView {
    func addBorderToViewAtPosition(position: BorderPosition, color: UIColor = UIColor.lightGrayColor(), andThickness thickness: CGFloat = 1) {
        let border = CALayer()
        switch position {
        case .Top:
            border.frame = CGRectMake(0, 0, self.frame.size.width, thickness)
        case .Bottom:
            border.frame = CGRectMake(0, self.bounds.height - thickness, self.frame.size.width, thickness)
        case .Left:
            border.frame = CGRectMake(0, 0, thickness, self.frame.size.height)
        }

        border.backgroundColor = color.CGColor
        self.layer.addSublayer(border)
    }
}

extension UIImageView {
    // Fades in image when it is set
    func setImageWithURLRequest(urlRequest: NSURLRequest, placeholderImage: UIImage?, fadeInWithDuration duration: NSTimeInterval) {
        self.setImageWithURLRequest(urlRequest, placeholderImage: placeholderImage, success: { (request: NSURLRequest, response: NSHTTPURLResponse?, image: UIImage) -> Void in
            
            UIView.transitionWithView(self, duration: duration, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: { () -> Void in
                self.image = image
                }, completion: nil)
            }, failure: { (request: NSURLRequest, response: NSHTTPURLResponse?, error: NSError) -> Void in
        })
    }
}