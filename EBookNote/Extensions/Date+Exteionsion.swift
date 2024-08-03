//
//  Date+Exteionsion.swift
//  EBookNote
//
//  Created by Nguyen Huu Hung on 7/20/24.
//

import Foundation

extension Date {
    static var getWeekday: [Date] {
        guard let currentDate = Calendar.current.date(bySettingHour: 23, minute: 59, second: 59, of: Date()) else { return [Date]() }
        let orderDay = currentDate.formatted(Date.FormatStyle().weekday(.wide))
        
        if orderDay == "Monday" {
            let monday = currentDate
            let tuesday = Calendar.current.date(byAdding: .day, value: 1, to: currentDate)!
            let wednesday = Calendar.current.date(byAdding: .day, value: 2, to: currentDate)!
            let thursday = Calendar.current.date(byAdding: .day, value: 3, to: currentDate)!
            let friday = Calendar.current.date(byAdding: .day, value: 4, to: currentDate)!
            let saturday = Calendar.current.date(byAdding: .day, value: 5, to: currentDate)!
            let sunday = Calendar.current.date(byAdding: .day, value: 6, to: currentDate)!
            return [monday, tuesday, wednesday, thursday, friday, saturday, sunday]
        } else if orderDay == "Tuesday" {
            let monday = Calendar.current.date(byAdding: .day, value: -1, to: currentDate)!
            let tuesday = currentDate
            let wednesday = Calendar.current.date(byAdding: .day, value: 1, to: currentDate)!
            let thursday = Calendar.current.date(byAdding: .day, value: 2, to: currentDate)!
            let friday = Calendar.current.date(byAdding: .day, value: 3, to: currentDate)!
            let saturday = Calendar.current.date(byAdding: .day, value: 4, to: currentDate)!
            let sunday = Calendar.current.date(byAdding: .day, value: 5, to: currentDate)!
            return [monday, tuesday, wednesday, thursday, friday, saturday, sunday]
        } else if orderDay == "Wednesday" {
            let monday = Calendar.current.date(byAdding: .day, value: -2, to: currentDate)!
            let tuesday = Calendar.current.date(byAdding: .day, value: -1, to: currentDate)!
            let wednesday = currentDate
            let thursday = Calendar.current.date(byAdding: .day, value: 1, to: currentDate)!
            let friday = Calendar.current.date(byAdding: .day, value: 2, to: currentDate)!
            let saturday = Calendar.current.date(byAdding: .day, value: 3, to: currentDate)!
            let sunday = Calendar.current.date(byAdding: .day, value: 4, to: currentDate)!
            return [monday, tuesday, wednesday, thursday, friday, saturday, sunday]
        } else if orderDay == "Thursday" {
            let monday = Calendar.current.date(byAdding: .day, value: -3, to: currentDate)!
            let tuesday = Calendar.current.date(byAdding: .day, value: -2, to: currentDate)!
            let wednesday = Calendar.current.date(byAdding: .day, value: -1, to: currentDate)!
            let thursday = currentDate
            let friday = Calendar.current.date(byAdding: .day, value: 1, to: currentDate)!
            let saturday = Calendar.current.date(byAdding: .day, value: 2, to: currentDate)!
            let sunday = Calendar.current.date(byAdding: .day, value: 3, to: currentDate)!
            return [monday, tuesday, wednesday, thursday, friday, saturday, sunday]
        } else if orderDay == "Friday" {
            let monday = Calendar.current.date(byAdding: .day, value: -4, to: currentDate)!
            let tuesday = Calendar.current.date(byAdding: .day, value: -3, to: currentDate)!
            let wednesday = Calendar.current.date(byAdding: .day, value: -2, to: currentDate)!
            let thursday = Calendar.current.date(byAdding: .day, value: -1, to: currentDate)!
            let friday = currentDate
            let saturday = Calendar.current.date(byAdding: .day, value: 1, to: currentDate)!
            let sunday = Calendar.current.date(byAdding: .day, value: 2, to: currentDate)!
            return [monday, tuesday, wednesday, thursday, friday, saturday, sunday]
        } else if orderDay == "Saturday" {
            let monday = Calendar.current.date(byAdding: .day, value: -5, to: currentDate)!
            let tuesday = Calendar.current.date(byAdding: .day, value: -4, to: currentDate)!
            let wednesday = Calendar.current.date(byAdding: .day, value: -3, to: currentDate)!
            let thursday = Calendar.current.date(byAdding: .day, value: -2, to: currentDate)!
            let friday = Calendar.current.date(byAdding: .day, value: -1, to: currentDate)!
            let saturday = currentDate
            let sunday = Calendar.current.date(byAdding: .day, value: 1, to: currentDate)!
            return [monday, tuesday, wednesday, thursday, friday, saturday, sunday]
        } else if orderDay == "Sunday" {
            let monday = Calendar.current.date(byAdding: .day, value: -6, to: currentDate)!
            let tuesday = Calendar.current.date(byAdding: .day, value: -5, to: currentDate)!
            let wednesday = Calendar.current.date(byAdding: .day, value: -4, to: currentDate)!
            let thursday = Calendar.current.date(byAdding: .day, value: -3, to: currentDate)!
            let friday = Calendar.current.date(byAdding: .day, value: -2, to: currentDate)!
            let saturday = Calendar.current.date(byAdding: .day, value: -1, to: currentDate)!
            let sunday = currentDate
            return [monday, tuesday, wednesday, thursday, friday, saturday, sunday]
        }
        
        return [Date]()
    }
    
    static var getLastWeek: [Date] {
        let mondayThisWeek = getWeekday[0]
        let mondayLastWeek = Calendar.current.date(byAdding: .day, value: -7, to: mondayThisWeek)!
        let tuesdayLastWeek = Calendar.current.date(byAdding: .day, value: -6, to: mondayThisWeek)!
        let wednesdayLastWeek = Calendar.current.date(byAdding: .day, value: -5, to: mondayThisWeek)!
        let thursdayLastWeek = Calendar.current.date(byAdding: .day, value: -4, to: mondayThisWeek)!
        let fridayLastWeek = Calendar.current.date(byAdding: .day, value: -3, to: mondayThisWeek)!
        let saturdayLastWeek = Calendar.current.date(byAdding: .day, value: -2, to: mondayThisWeek)!
        let sundayLastWeek = Calendar.current.date(byAdding: .day, value: -1, to: mondayThisWeek)!
        return [mondayLastWeek, tuesdayLastWeek, wednesdayLastWeek, thursdayLastWeek, fridayLastWeek, saturdayLastWeek, sundayLastWeek]
    }
    
    static func formatDateToString(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateString = formatter.string(from: date)
        let formatDate = formatter.date(from: dateString)!
        formatter.dateFormat = "MM/dd/yyyy"
        return formatter.string(from: formatDate)
    }
}
