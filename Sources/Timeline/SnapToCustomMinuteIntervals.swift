import Foundation

public final class SnapToCustomMinuteIntervals: EventEditingSnappingBehavior {
    public var calendar: Calendar

    // Optional override for the snapping minute. Valid range: 1...59.
    // When nil or invalid, a sensible default of 15 minutes is used.
    public var minuteInterval: Int?

    public init(minuteInterval: Int? = nil, calendar: Calendar = .autoupdatingCurrent) {
        self.minuteInterval = minuteInterval
        self.calendar = calendar
    }

    public func nearestDate(to date: Date) -> Date {
        let m = (minuteInterval ?? 15)
        let interval = (1...59).contains(m) ? m : 15

        let comps = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date)
        let minute = comps.minute ?? 0

        // Round to nearest multiple of `interval`
        let lower = (minute / interval) * interval
        let upper = min(59, lower + interval)
        let toUpper = minute - lower >= upper - minute
        let snappedMinute = toUpper ? upper : lower

        return calendar.date(bySettingHour: comps.hour ?? 0, minute: snappedMinute, second: 0, of: date) ?? date
    }

    public func accentedHour(for date: Date) -> Int {
        return calendar.component(.hour, from: date)
    }

    public func accentedMinute(for date: Date) -> Int {
        let interval = (1...59).contains(minuteInterval ?? 15) ? (minuteInterval ?? 15) : 15
        let minute = Double(calendar.component(.minute, from: date))
        let value = interval * Int(round(minute / Double(interval)))
        return value < 60 ? value : 0
    }
}
