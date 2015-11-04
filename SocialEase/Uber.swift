//
//  Uber.swift
//
//  Created by Kirby Shabaga on 9/9/14
//  Updated by Kirby Shabaga on 11/3/15
//
//  Ref: https://developer.uber.com/v1/deep-linking/
//

import CoreLocation
import Foundation
import UIKit

class Uber {
    
    // required property
    var pickupLocation : CLLocationCoordinate2D!
    
    // optional properties
    var pickupNickname : String?
    var pickupFormattedAddress : String?
    
    var dropoffLocation : CLLocationCoordinate2D?
    var dropoffNickname : String?
    var dropoffFormattedAddress : String?
    
    // -------------------------------------------------------------------
    // init with required property
    // -------------------------------------------------------------------
    init(pickupLocation : CLLocationCoordinate2D) {
        self.pickupLocation = pickupLocation
    }
    
    // -------------------------------------------------------------------
    // perform a deep link to the Uber App if installed
    // check all optional properties while construcing the URL
    // -------------------------------------------------------------------
    func deepLink() {
        if let uberURL = self.constructURL() {
            let sharedApp = UIApplication.sharedApplication()
            print(uberURL)
            sharedApp.openURL(uberURL)
        } else {
            print("No uber app")
        }
    }
    
    private func constructURL() -> NSURL? {
        
        if Uber.isUberAppInstalled() {
            return self.constructUberApp()
        } else {
            return self.constructUberHttps()
        }

    }
    
    private func constructUberApp() -> NSURL? {
        
        var uberString = "uber://"
        
        uberString += "?action=setPickup"
        uberString += "&pickup[latitude]=\(self.pickupLocation.latitude)"
        uberString += "&pickup[longitude]=\(self.pickupLocation.longitude)"
        
        uberString += self.pickupNickname == nil ? "" :
        "&pickup[nickname]=\(self.pickupNickname!)"
        
        uberString += self.pickupFormattedAddress == nil ? "" :
        "&pickup[formatted_address]=\(self.pickupFormattedAddress!)"
        
        if self.dropoffLocation != nil {
            uberString += "&dropoff[latitude]=\(self.dropoffLocation!.latitude)"
            uberString += "&dropoff[longitude]=\(self.dropoffLocation!.longitude)"
        }
        
        uberString += self.dropoffNickname == nil ? "" :
        "&dropoff[nickname]=\(self.dropoffNickname!)"
        
        uberString += self.dropoffFormattedAddress == nil ? "" :
        "&dropoff[formatted_address]=\(self.dropoffFormattedAddress!)"
        
        
        if let urlEncodedString = uberString.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet()) {
            return NSURL(string: urlEncodedString)
        } else {
            return nil
        }
    }
    
    private func constructUberHttps() -> NSURL? {
        
        var uberString = "https://m.uber.com/sign-up?client_id=YOUR_CLIENT_ID"
        
        uberString += "&pickup_latitude=\(self.pickupLocation.latitude)"
        uberString += "&pickup_longitude=\(self.pickupLocation.longitude)"
        
        uberString += self.pickupNickname == nil ? "" :
        "&pickup_nickname=\(self.pickupNickname!)"
        
        uberString += self.pickupFormattedAddress == nil ? "" :
        "&pickup_formatted_address=\(self.pickupFormattedAddress!)"
        
        if self.dropoffLocation != nil {
            uberString += "&dropoff_latitude=\(self.dropoffLocation!.latitude)"
            uberString += "&dropoff_longitude=\(self.dropoffLocation!.longitude)"
        }
        
        uberString += self.dropoffNickname == nil ? "" :
        "&dropoff_nickname=\(self.dropoffNickname!)"
        
        uberString += self.dropoffFormattedAddress == nil ? "" :
        "&dropoff_formatted_address=\(self.dropoffFormattedAddress!)"
        
        
        if let urlEncodedString = uberString.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet()) {
            return NSURL(string: urlEncodedString)
        } else {
            return nil
        }
    }
    
    // -------------------------------------------------------------------
    // check if the Uber App is installed on the device
    // -------------------------------------------------------------------
    class func isUberAppInstalled() -> Bool {
        let sharedApp = UIApplication.sharedApplication()
        let uberProtocol = NSURL(string: "uber://")
        
        return sharedApp.canOpenURL(uberProtocol!)
    }
    
}