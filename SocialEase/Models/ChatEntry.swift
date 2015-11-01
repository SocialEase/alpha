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
    
    class func getChatEntriesForPlan(planId: String, usersInPlan: [User], completion: ([ChatEntry]?, ErrorType?) -> ()) {
        let predicate = NSPredicate(format: "planId == '\(planId)'")
        let query = PFQuery(className: "ChatEntry", predicate: predicate)
        query.findObjectsInBackgroundWithBlock { (optionalChatEntries, error) -> Void in
            if let chatEntries = optionalChatEntries {
                // build userId to User model dictionary
                var userIdUserMap = [String: User]()
                for user in usersInPlan {
                    userIdUserMap[user.id!] = user
                }
                
                var chatEntryArray = [ChatEntry]()
                for pfObject in chatEntries {
                    let chatText = pfObject["chatText"] as! String
                    let userId = pfObject["userId"] as! String
                    
                    let chatEntry = ChatEntry()
                    chatEntry.user = userIdUserMap[userId]
                    chatEntry.chatText = chatText
                    chatEntry.chatTimeStamp = pfObject.createdAt
                    
                    chatEntryArray.append(chatEntry)
                }
                completion(chatEntryArray, nil)
                return
            }
            completion(nil, error)
        }
    }
    
    

}
