/**
 * Copyright (C) 2019 Extension All Rights Reserved.
 */

import Foundation

enum WeekDay: Int {
    case sun = 1
    case mon
    case tue
    case wed
    case thu
    case fri
    case sat
}

enum DateFormat: String {
    /** yyyy-MM-dd HH:mm:ss */
    case dateTime24 = "yyyy-MM-dd HH:mm:ss"
    /** yyyy-MM-dd HH:mm:ss Z */
    case dateTime24Z = "yyyy-MM-dd HH:mm:ss Z"
    /** yyyy-MM-dd hh:mm:ss a */
    case dateTime12 = "yyyy-MM-dd hh:mm:ss a"
    /** yyyy-MM-dd hh:mm:ss a Z */
    case dateTime12Z = "yyyy-MM-dd hh:mm:ss a Z"
    /** yyyy-MM-dd HH:mm */
    case dateTime24NoSec = "yyyy-MM-dd HH:mm"
    /** yyyy-MM-dd hh:mm a */
    case dateTime12NoSec = "yyyy-MM-dd hh:mm a"
    /** yyyy-MM-dd */
    case date = "yyyy-MM-dd"
    /** HH:mm:ss */
    case time24 = "HH:mm:ss"
    /** hh:mm:ss a */
    case time12 = "hh:mm:ss a"
    /** HH:mm */
    case time24NoSec = "HH:mm"
    /** hh:mm a */
    case time12NoSec = "hh:mm a"

    /** yyyy-MM-dd'T'HH:mm:ss */
    case tDateTime = "yyyy-MM-dd'T'HH:mm:ss"
    /** yyyy-MM-dd'T'HH:mm:ss.SSS'Z' */
    case tDateTime3 = "yyyy-MM-dd'T'HH:mm:ss.SSS"
    /** yyyy-MM-dd'T'HH:mm:ss.SSSSSS */
    case tDateTime6 = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"

    /** yyyy-MM-dd'T'HH:mm:ss'Z' */
    case tzDateTime = "yyyy-MM-dd'T'HH:mm:ss'Z'"
    /** yyyy-MM-dd'T'HH:mm:ss.SSS'Z' */
    case tzDateTime3 = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
    /** yyyy-MM-dd'T'HH:mm:ss.SSSSSS'Z' */
    case tzDateTime6 = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS'Z'"

    /** dd/MM/yyyy */
    case dateMonthYear = "yyyy/MM/dd"
    /** dd/MM */
    case dateMonth = "MM/dd"
    /** yyyy/MM */
    case yearMonth = "yyyy/MM"
    /** "dd/MM/yyyy - HH:mm" */
    case dateWeekDay = "(EEE) dd/MM/yyyy"
    
    case dateJapan = "yyyy年MM月dd日"
    
    case monthYear = "MM/yyyy"
}

// MARK: - Date

extension Date {
    func japan(format: String? = nil, localized: Bool) -> String {
        let dateFormatter = DateFormatter()
        if let format = format {
            dateFormatter.dateFormat = format
        } else {
            dateFormatter.dateStyle = DateFormatter.Style.long
        }
        dateFormatter.locale = Locale(identifier: "ja_JP")
        dateFormatter.timeZone = localized ? TimeZone.current : TimeZone.utcTimeZone()
        return dateFormatter.string(from: self)
    }

    func timeAgo() -> String {
        let minuteInterval: TimeInterval = 60
        let hourInterval: TimeInterval = 3600
        let dayInterval: TimeInterval = hourInterval * 24
        let timeInterval = abs(timeIntervalSince(Date()))
        if timeInterval < hourInterval {
            let minute = floor(timeInterval / minuteInterval)
            return "\(Int(minute == 0 ? 1 : minute))分前"
        } else if timeInterval < dayInterval {
            let hour = floor(timeInterval / hourInterval)
            return "\(Int(hour))時間前"
        } else if timeInterval <= dayInterval * 7 {
            let day = floor(timeInterval / dayInterval)
            return "\(Int(day))日前"
        } else {
            return toString(format: "yyyy/MM/dd", localized: false)
        }
    }

    func age() -> Int? {
        let calendar = Calendar(identifier: .gregorian)
        return calendar.dateComponents([.year], from: self, to: Date.now).year
    }
}

// MARK: - TimeInterval

extension TimeInterval {
    var time: String {
        var mm = Int(trunc(self / 60))
        let hh = mm / 60
        mm %= 60
        if hh < 1 {
            return "\(mm)m"
        } else {
            return "\(hh)h\(mm)m"
        }
    }

    var clock: String {
        var duration = Int(self)
        let hour = duration / 3600
        duration %= 3600
        let mins = duration / 60
        duration %= 60
        let secs = duration
        let suffix = String(format: "%@%d:%@%d", mins > 9 ? "" : "0", mins, secs > 9 ? "" : "0", secs)
        let prefix = hour > 0 ? String(format: "%@%d:", hour > 9 ? "" : "0", hour) : ""
        return String(format: "%@%@", prefix, suffix)
    }
}

// MARK: - String

extension String {
    func toDate(format: String, localized: Bool = true) -> Date {
        return Date(str: self, format: format, localized: localized)
    }

    func toDate(format: DateFormat, localized: Bool = true) -> Date {
        return Date(str: self, format: format.rawValue, localized: localized)
    }
}

// MARK: - Date

extension Date {
    static var zero: Date {
        var comps = DateComponents(year: 0, month: 1, day: 1)
        comps.timeZone = TimeZone.utcTimeZone()
        var calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        calendar.timeZone = TimeZone.utcTimeZone()
        return calendar.date(from: comps) ?? Date()
    }

    init(str: String, format: String, localized: Bool) {
        let fmt = DateFormatter.fromFormat(format: format)
        fmt.timeZone = localized ? TimeZone.current : TimeZone.utcTimeZone()
        if let date = fmt.date(from: str) {
            self.init(timeInterval: 0, since: date)
        } else {
            self.init(timeInterval: 0, since: Date.zero)
        }
    }

    func toString(format: String, localized: Bool = true) -> String {
        let fmt = DateFormatter.fromFormat(format: format)
        fmt.timeZone = localized ? TimeZone.current : TimeZone.utcTimeZone()
        return fmt.string(from: self)
    }

    func toString(format: DateFormat, localized: Bool = true) -> String {
        let fmt = DateFormatter.fromFormat(format: format.rawValue)
        fmt.timeZone = localized ? TimeZone.current : TimeZone.utcTimeZone()
        return fmt.string(from: self)
    }
}

// MARK: - TimeZone

extension TimeZone {
    static func utcTimeZone() -> TimeZone {
        return TimeZone(secondsFromGMT: 0) ?? TimeZone.current
    }
}

// MARK: - NSDateComponents

extension NSDateComponents {
    convenience init(year: Int, month: Int, day: Int, hour: Int = 0, minute: Int = 0, sec: Int = 0, nsec: Int = 0) {
        self.init()
        self.year = year
        self.month = month
        self.day = day
        self.hour = hour
        self.minute = minute
        second = sec
        nanosecond = nsec
    }
}

var fmts: [String: DateFormatter] = [String: DateFormatter]()
let lock = NSLock()
let dayTime: Double = 60 * 60 * 24
let hourTime: Double = 60 * 60
let minuteTime: Double = 60

// MARK: - DateFormatter

extension DateFormatter {
    static func fromFormat(format: String!) -> DateFormatter {
        lock.lock()
        var fmt: DateFormatter!
        if let existFmt = fmts[format] {
            fmt = existFmt
        } else {
            fmt = DateFormatter()
            fmt.dateFormat = format
            fmts[format] = fmt
        }
        lock.unlock()
        return fmt
    }

    static let iso8601NoT: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.timeZone = TimeZone.utcTimeZone()
        return formatter
    }()
}

struct DateRange {
    var start: Date!
    var end: Date!
}

extension Date {
    static var now: Date {
        return Date()
    }

    var timestamp: TimeInterval {
        return timeIntervalSince1970 * 1000
    }

    var begin: Date {
        return Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: self) ?? Date.now
    }

    var end: Date {
        return Calendar.current.date(bySettingHour: 23, minute: 59, second: 0, of: self) ?? Date.now
    }

    var yesterday: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: self) ?? Date.now
    }

    var tomorrow: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: self) ?? Date.now
    }

    var noon: Date {
        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self) ?? Date.now
    }

    var hour: Int {
        return Calendar.current.component(.hour, from: self)
    }

    var minute: Int {
        return Calendar.current.component(.minute, from: self)
    }

    var day: Int {
        return Calendar.current.component(.day, from: self)
    }

    var month: Int {
        return Calendar.current.component(.month, from: self)
    }

    var year: Int {
        return Calendar.current.component(.year, from: self)
    }

    var weekday: WeekDay {
        let weekDay = Calendar.current.component(.weekday, from: self)
        return WeekDay(rawValue: weekDay) ?? .mon
    }

    func setDate(withHour hour: Int, minute: Int) -> Date {
        var calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        calendar.timeZone = TimeZone.current
        return calendar.date(bySettingHour: hour, minute: minute, second: 0, of: self) ?? Date.now
    }

    func minute(adding value: Int) -> Date {
        return Calendar.current.date(byAdding: .minute, value: value, to: self) ?? Date.now
    }

    func date(adding value: Int) -> Date {
        return Calendar.current.date(byAdding: .day, value: value, to: self) ?? Date.now
    }

    func year(adding value: Int) -> Date {
        return Calendar.current.date(byAdding: .year, value: value, to: self) ?? Date.now
    }

    func month(adding value: Int) -> Date {
        return Calendar.current.date(byAdding: .month, value: value, to: self) ?? Date.now
    }
}

extension Date {
    func getLast6Month() -> Date? {
        return Calendar.current.date(byAdding: .month, value: -6, to: self)
    }

    func getLast3Month() -> Date? {
        return Calendar.current.date(byAdding: .month, value: -3, to: self)
    }

    func getYesterday() -> Date? {
        return Calendar.current.date(byAdding: .day, value: -1, to: self)
    }

    func getLast7Day() -> Date? {
        return Calendar.current.date(byAdding: .day, value: -7, to: self)
    }

    func getLast30Day() -> Date? {
        return Calendar.current.date(byAdding: .day, value: -30, to: self)
    }

    func getPreviousMonth() -> Date? {
        return Calendar.current.date(byAdding: .month, value: -1, to: self)
    }

    // This Month Start
    var startMonth: Date {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone.utcTimeZone()
        let components = calendar.dateComponents([.year, .month], from: self)
        return calendar.date(from: components) ?? Date.now
    }

    var endMonth: Date {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone.utcTimeZone()
        let components = calendar.dateComponents([.year, .month], from: self) as NSDateComponents
        components.month += 1
        components.day = 1
        components.day -= 1
        return calendar.date(from: components as DateComponents) ?? Date.now
    }

    // Last Month Start
    func getLastMonthStart() -> Date? {
        let components: NSDateComponents = Calendar.current.dateComponents([.year, .month], from: self) as NSDateComponents
        components.month -= 1
        return Calendar.current.date(from: components as DateComponents) ?? Date.now
    }

    // Last Month End
    func getLastMonthEnd() -> Date? {
        let components: NSDateComponents = Calendar.current.dateComponents([.year, .month], from: self) as NSDateComponents
        components.day = 1
        components.day -= 1
        return Calendar.current.date(from: components as DateComponents) ?? Date.now
    }

    func components(to day: Date) -> DateComponents {
        let calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: self, to: day)
        return components
    }
}

extension Date {
    func dayOfWeek() -> String {
        switch weekday {
        case .sun:
            return "Chủ nhật"
        default:
            return "Thứ \(weekday.rawValue)"
        }
    }
}

enum DateRoundingType {
    case round
    case ceil
    case floor
}

extension Date {
    func rounded(minutes: TimeInterval, rounding: DateRoundingType = .round) -> Date {
        return rounded(seconds: minutes * 60, rounding: rounding)
    }

    func rounded(seconds: TimeInterval, rounding: DateRoundingType = .round) -> Date {
        var roundedInterval: TimeInterval = 0
        switch rounding {
        case .round:
            roundedInterval = (timeIntervalSinceReferenceDate / seconds).rounded() * seconds
        case .ceil:
            roundedInterval = ceil(timeIntervalSinceReferenceDate / seconds) * seconds
        case .floor:
            roundedInterval = floor(timeIntervalSinceReferenceDate / seconds) * seconds
        }
        return Date(timeIntervalSinceReferenceDate: roundedInterval)
    }

    func getElapsedInterval() -> String {
        let interval = Calendar.current.dateComponents([.year, .month, .day, .hour], from: self, to: Date())
        if let year = interval.year, year > 0 {
            return year == 1 ? "\(year)" + " " + "year ago" :
                "\(year)" + " " + "years ago"
        } else if let month = interval.month, month > 0 {
            return month == 1 ? "\(month)" + " " + "month ago" :
                "\(month)" + " " + "months ago"
        } else if let day = interval.day, day > 0 {
            return day == 1 ? "\(day)" + " " + "day ago" :
                "\(day)" + " " + "days ago"
        } else if let hour = interval.hour, hour > 0 {
            return hour == 1 ? "\(hour)" + " " + "hour ago" :
                "\(hour)" + " " + "hours ago"
        } else {
            return "a moment ago"
        }
    }

    func checkNear1Hour(date: Date) -> Bool {
        return abs(timeIntervalSince(date)) <= hourTime
    }
}

extension DateInterval {
    func start(byAdding components: Calendar.Component, value: Int) -> DateInterval {
        guard let newStart = Calendar.current.date(byAdding: components, value: value, to: start) else {
            return DateInterval(start: Date.now, end: Date.now)
        }
        return DateInterval(start: newStart, end: end)
    }

    func end(byAdding components: Calendar.Component, value: Int) -> DateInterval {
        guard let newEnd = Calendar.current.date(byAdding: components, value: value, to: end) else {
            return DateInterval(start: Date.now, end: Date.now)
        }
        return DateInterval(start: start, end: newEnd)
    }
}
