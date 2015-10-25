//
//  DisplayPlanVC.swift
//  SocialEase
//
//  Created by Amay Singhal on 10/23/15.
//  Copyright © 2015 Yuichi Kuroda. All rights reserved.
//

import UIKit


protocol DisplayPlanVC: class {

    var title: String { get }
    var index: Int { get }
    var planStatus: UserPlanStatus { get }
    var planDisplayVC: PlanDisplayViewController { get set }
}


class DisplayActivePlansVC: DisplayPlanVC {

    private let _title = "Active"
    var title: String {
        return _title
    }

    private let _index = 0
    var index: Int {
        return _index
    }

    private let _status = UserPlanStatus.Active
    var planStatus: UserPlanStatus {
        return _status
    }

    private var _viewController: PlanDisplayViewController!
    var planDisplayVC: PlanDisplayViewController {
        get {
            return _viewController
        }
        set(newValue) {
            newValue.pageIndex = _index
            newValue.pageTitle = _title
            newValue.planStatus = _status
            _viewController = newValue
        }
    }
}

class DisplayPendingPlansVC: DisplayPlanVC {

    private let _title = "Pending"
    var title: String {
        return _title
    }

    private let _index = 1
    var index: Int {
        return _index
    }

    private let _status = UserPlanStatus.Pending
    var planStatus: UserPlanStatus {
        return _status
    }

    private var _viewController: PlanDisplayViewController!
    var planDisplayVC: PlanDisplayViewController {
        get {
            return _viewController
        }
        set(newValue) {
            newValue.pageIndex = _index
            newValue.pageTitle = _title
            newValue.planStatus = _status
            _viewController = newValue
        }
    }
}