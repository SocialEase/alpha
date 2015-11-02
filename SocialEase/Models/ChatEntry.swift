//
//  ChatEntry.swift
//  SocialEase
//
//  Created by Uday on 10/31/15.
//  Copyright © 2015 udaymitra. All rights reserved.
//

import UIKit
import Parse

class ChatEntry: NSObject {
    var user: User!
    var chatText: String?
    var chatTimeStamp: NSDate?
    var planId: String!
    var pfObject: PFObject!
    var imagePFFile: PFFile?

    func formattedTimeString() -> String {
        return DateUtils.getSystemStyleDisplayDate(chatTimeStamp!, dateStyle: NSDateFormatterStyle.ShortStyle, timeStyle: NSDateFormatterStyle.ShortStyle, timezone: nil)
    }

    class func getChatEntriesForPlan(planId: String, usersInPlan: [User], completion: ([ChatEntry]?, ErrorType?) -> ()) {
        let predicate = NSPredicate(format: "planId == '\(planId)'")
        let query = PFQuery(className: "ChatEntry", predicate: predicate)
        query.orderByAscending("createdAt")
        query.findObjectsInBackgroundWithBlock { (optionalChatEntries, error) -> Void in
            if let chatEntries = optionalChatEntries {
                // build userId to User model dictionary
                var userIdUserMap = [String: User]()
                for user in usersInPlan {
                    userIdUserMap[user.id!] = user
                }
                
                var chatEntryArray = [ChatEntry]()
                for pfObject in chatEntries {
                    let chatText = pfObject["chatText"] as? String
                    let userId = pfObject["userId"] as! String
                    let _ = pfObject["planId"] as! String
                    let pfFile = pfObject["media"] as? PFFile
                    

                    let chatEntry = ChatEntry()
                    chatEntry.pfObject = pfObject
                    chatEntry.user = userIdUserMap[userId]
                    chatEntry.chatText = chatText
                    chatEntry.chatTimeStamp = pfObject.createdAt
                    chatEntry.imagePFFile = pfFile
                    
                    chatEntryArray.append(chatEntry)
                }
                completion(chatEntryArray, nil)
                return
            }
            completion(nil, error)
        }
    }
    
    func saveToParseInBackground() {
        let pfObject = PFObject(className: "ChatEntry")
        pfObject["chatText"] = self.chatText
        pfObject["userId"] = self.user.pfUser!.objectId!
        pfObject["planId"] = self.planId
        pfObject.saveInBackgroundWithBlock { (succeeded, error) -> Void in
            if (error != nil) {
                print("Oops! couldnt write chat entry to parse")
            }
        }
    }

}
