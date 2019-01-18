//
//  TimerUtil.swift
//  NewDawn
//
//  Created by 汤子毅 on 2019/1/16.
//  Copyright © 2019 New Dawn. All rights reserved.
//

import Foundation

let STORED_DATE = "stored_date"

struct DateTuple: Codable, Comparable {
    var year: Int
    var month: Int
    var day: Int
    init(year: Int, month: Int, day: Int) {
        self.year = year
        self.month = month
        self.day = day
    }
    
    static func == (lhs: DateTuple, rhs: DateTuple) -> Bool {
        return lhs.year == rhs.year &&
            lhs.month == rhs.month &&
            lhs.day == rhs.day
    }
    
    static func < (lhs: DateTuple, rhs: DateTuple) -> Bool {
        return lhs.year < rhs.year ||
            (lhs.year == rhs.year && lhs.month < rhs.month) ||
            (lhs.year == rhs.year && lhs.month == rhs.month && lhs.day < rhs.day)
    }
}

class TimerUtil {
    // A helper function to get current date
    static func getCurrentDate() -> DateTuple {
        let currentDateTime = Date()
        let userCalendar = Calendar.current
        let requestedComponents: Set<Calendar.Component> = [
            .year,
            .month,
            .day,
            .hour,
            .minute,
            .second
        ]
        // get the components
        let dateTimeComponents = userCalendar.dateComponents(requestedComponents, from: currentDateTime)
        return DateTuple(year: dateTimeComponents.year!, month: dateTimeComponents.month!, day: dateTimeComponents.day!)
    }
    
    // A helper function to store the latest date
    static func setStoredDate(date: DateTuple) -> Void {
        LocalStorageUtil.localStoreKeyValueStruct(key: STORED_DATE, value: date)
    }
    
    // A helper function to get the latest date
    static func readStoredDate() -> DateTuple {
        if let stored_date: DateTuple = LocalStorageUtil.localReadKeyValueStruct(key: STORED_DATE) {
            return stored_date
        } else {
            let currentDate = getCurrentDate()
            setStoredDate(date: currentDate)
            return currentDate
        }
    }
    
    // A helper function to check if current date surpasses the latest date
    static func isOutdated(always: Bool = true) -> Bool {
        // TODO: Make always default to false
        return always || getCurrentDate() > readStoredDate()
    }
    
    // A helper function to update the stored data
    static func updateDate() -> Void {
        setStoredDate(date: getCurrentDate())
    }
}
