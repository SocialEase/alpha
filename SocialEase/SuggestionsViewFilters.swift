//
//  AppUtils.swift
//  SocialEaseSuggestionsWorkflow
//
//  Created by Amay Singhal on 10/18/15.
//  Copyright © 2015 ple. All rights reserved.
//

import Foundation

protocol SuggestionsFilter: class {

    var displayName: String { get }
    var isSelected: Bool { get set }
}

class DisplayDateFilter: SuggestionsFilter {

    var date: NSDate
    var selected: Bool

    var displayName: String {
        return DateUtils.getDisplayDate(date)
    }

    var isSelected: Bool {
        get {
            return selected
        }
        set(newValue) {
            selected = newValue
        }
    }

    init(date: NSDate, isSelected selected: Bool) {
        self.date = date
        self.selected = selected
    }

    class func getDateFilterListFromDate(date: NSDate) -> [SuggestionsFilter] {
        var dateFilterList = [SuggestionsFilter]()
        let dates = DateUtils.getNextNDatesWithCount(7, fromStartDate: date)
        dateFilterList.append(DisplayDateFilter(date: dates[0], isSelected: true))
        for i in 1 ..< dates.count {
            dateFilterList.append(DisplayDateFilter(date: dates[i], isSelected: false))
        }
        return dateFilterList
    }
}



class DisplayActivityTypeFilter: SuggestionsFilter {

    var activityName: String
    var selected: Bool

    var displayName: String {
        return activityName
    }

    var isSelected: Bool {
        get {
            return selected
        }
        set(newValue) {
            selected = newValue
        }
    }

    init(name: String, isSelected selected: Bool) {
        activityName = name
        self.selected = selected
    }

    class func getActivityTypeFilterList() -> [SuggestionsFilter] {
        var activityTypeFilterList = [SuggestionsFilter]()
        activityTypeFilterList.append(DisplayActivityTypeFilter(name: "Lunch", isSelected: true))
        activityTypeFilterList.append(DisplayActivityTypeFilter(name: "Dinner", isSelected: false))
        activityTypeFilterList.append(DisplayActivityTypeFilter(name: "Coffee", isSelected: false))
        activityTypeFilterList.append(DisplayActivityTypeFilter(name: "Happy Hour", isSelected: false))
        activityTypeFilterList.append(DisplayActivityTypeFilter(name: "Hiking", isSelected: false))
        return activityTypeFilterList
    }
}