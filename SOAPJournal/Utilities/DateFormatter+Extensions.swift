import Foundation

extension DateFormatter {
    
    // 日付と時間を表示するためのフォーマッター
    static let fullDateTimeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        formatter.timeStyle = .short
        formatter.locale = Locale.current
        return formatter
    }()
    
    // 日付のみを表示するためのフォーマッター
    static let fullDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        formatter.timeStyle = .none
        formatter.locale = Locale.current
        return formatter
    }()
    
    // 短い形式の日付フォーマッター
    static let shortDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        formatter.locale = Locale.current
        return formatter
    }()
    
    // カレンダー表示用の月フォーマッター
    static let monthFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年MM月"
        formatter.locale = Locale(identifier: "ja_JP")
        return formatter
    }()
    
    // カレンダー表示用の曜日フォーマッター
    static let weekdayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "E"  // 短い曜日形式
        formatter.locale = Locale.current
        return formatter
    }()
}

extension Date {
    // 日付の表示用文字列を取得
    var displayString: String {
        return DateFormatter.fullDateFormatter.string(from: self)
    }
    
    // 短い日付文字列を取得
    var shortDisplayString: String {
        return DateFormatter.shortDateFormatter.string(from: self)
    }
    
    // 日付が今日かどうかを判定
    var isToday: Bool {
        return Calendar.current.isDateInToday(self)
    }
    
    // 日付が同じ月かどうかを判定
    func isSameMonth(as date: Date) -> Bool {
        let calendar = Calendar.current
        let components1 = calendar.dateComponents([.year, .month], from: self)
        let components2 = calendar.dateComponents([.year, .month], from: date)
        return components1.year == components2.year && components1.month == components2.month
    }
}