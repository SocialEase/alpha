//
//  AppNotifications.swift
//  SocialEase
//
//  Created by Amay Singhal on 11/1/15.
//  Copyright © 2015 Yuichi Kuroda. All rights reserved.
//

import UIKit

struct SEAPlanStatusDidChangeNotification {
    static let Name = "SEAPlanStatusDidChange"

    struct UserInfoKeys {
        static let PlanObject = "plan"
        static let FromStatus = "fromStatus"
        static let ToStatus = "toStatus"
    }
}



struct SEAPlanCreatedNotification {
    static let Name = "SEAPlanCreated"

    struct UserInfoKeys {
        static let PlanObject = "plan"
        static let PlanStatus = "planStatus"
    }
}