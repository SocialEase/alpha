//
//  DateUtils.swift
//  SocialEaseSuggestionsWorkflow
//
//  Created by Amay Singhal on 10/18/15.
//  Copyright © 2015 ple. All rights reserved.
//

import Foundation

class DateUtils {


    private static let DateFormatter = NSDateFormatter()
    private static let CurrentCalendar = NSCalendar.currentCalendar()
    static let PraseDateStringFormat = "yyyy-MM-dd HH:mm:ss Z"

    class func getNextNDatesWithCount(numberofDays: Int, fromStartDate date: NSDate) -> [NSDate] {

        var date = DateUtils.CurrentCalendar.startOfDayForDate(date)

        var dateList = [NSDate]()
        for _ in 1 ... numberofDays {
            dateList.append(date)
            // get next date
            date = DateUtils.CurrentCalendar.dateByAddingUnit(NSCalendarUnit.Day, value: 1, toDate: date, options: [])!
        }

        return dateList
    }

    class func getDisplayDatesList(datesList:[NSDate]) -> [String] {
        return datesList.map { DateUtils.getDisplayDate($0) }
    }

    class func getSystemStyleDisplayDate(date: NSDate, dateStyle: NSDateFormatterStyle = .LongStyle, timeStyle: NSDateFormatterStyle = .ShortStyle, timezone: NSTimeZone? = nil) -> String {
        DateUtils.DateFormatter.dateStyle = dateStyle
        DateUtils.DateFormatter.timeStyle = timeStyle
        DateUtils.DateFormatter.doesRelativeDateFormatting = true
        DateUtils.DateFormatter.timeZone = timezone ?? NSTimeZone(abbreviation: NSTimeZone.localTimeZone().abbreviation!)
        return DateUtils.DateFormatter.stringFromDate(date)
    }

    class func getDisplayDate(date: NSDate) -> String {
        DateUtils.DateFormatter.dateStyle = .MediumStyle
        DateUtils.DateFormatter.doesRelativeDateFormatting = true
        return DateUtils.DateFormatter.stringFromDate(date)
    }

    class func getDateFromParseString(parseDateString: String) -> NSDate? {
        DateUtils.DateFormatter.dateFormat = DateUtils.PraseDateStringFormat
        return DateUtils.DateFormatter.dateFromString(parseDateString)
    }
}