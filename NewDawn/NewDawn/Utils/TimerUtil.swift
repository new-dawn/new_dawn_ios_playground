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
    var hour: Int
    var minute: Int
    var second: Int
    init(year: Int, month: Int, day: Int, hour: Int, minute: Int, second: Int) {
        self.year = year
        self.month = month
        self.day = day
        self.hour = hour
        self.minute = minute
        self.second = second
    }
    
    static func == (lhs: DateTuple, rhs: DateTuple) -> Bool {
        return [lhs.year, lhs.month, lhs.day, lhs.hour, lhs.minute, lhs.second].elementsEqual([rhs.year, rhs.month, rhs.day, rhs.hour, rhs.minute, rhs.second])
    }
    
    static func < (lhs: DateTuple, rhs: DateTuple) -> Bool {
        return [lhs.year, lhs.month, lhs.day, lhs.hour, lhs.minute, lhs.second].lexicographicallyPrecedes([rhs.year, rhs.month, rhs.day, rhs.hour, rhs.minute, rhs.second])
    }
}

class TimerUtil {
    static let REFRESH_TIME_IN_SEC = 60
    
    static func buildDateTuple(date: DateComponents) -> DateTuple {
        return DateTuple(
            year: date.year!,
            month: date.month!,
            day: date.day!,
            hour: date.hour!,
            minute: date.minute!,
            second: date.second!
        )
    }
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
        return buildDateTuple(date: dateTimeComponents)
    }
    // A helper function to get current date
    static func getRefreshDate() -> DateTuple {
        let currentDateTime = Date()
        let userCalendar = Calendar.current
        let refreshDate = Calendar.current.date(byAdding: .second, value: REFRESH_TIME_IN_SEC, to: currentDateTime)
        let requestedComponents: Set<Calendar.Component> = [
            .year,
            .month,
            .day,
            .hour,
            .minute,
            .second
        ]
        // get the components
        let dateTimeComponents = userCalendar.dateComponents(requestedComponents, from: refreshDate ?? currentDateTime)
        return buildDateTuple(date: dateTimeComponents)
    }
    
    // A helper function to store the latest date
    static func storeRefreshDate() -> Void {
        LocalStorageUtil.localStoreKeyValueStruct(key: STORED_DATE, value: getRefreshDate())
    }
    
    // A helper function to get the latest date
    static func readRefreshDate() -> DateTuple {
        if let stored_date: DateTuple = LocalStorageUtil.localReadKeyValueStruct(key: STORED_DATE) {
            return stored_date
        } else {
            storeRefreshDate()
            return getRefreshDate()
        }
    }
    
    // A helper function to check if current date surpasses the latest date
    static func checkIfOutdatedAndRefresh() -> Bool {
        if getCurrentDate() > readRefreshDate() {
            storeRefreshDate()
            return true
        } else {
            return false
        }
    }
}
