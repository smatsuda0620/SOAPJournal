import SwiftUI

struct CalendarDayView: View {
    let date: Date
    let hasEntry: Bool
    let isSelected: Bool
    
    private let calendar = Calendar.current
    
    var body: some View {
        ZStack {
            Circle()
                .fill(backgroundColor)
                .aspectRatio(1, contentMode: .fit)
            
            Text("\(day)")
                .fontWeight(isToday ? .bold : .regular)
                .foregroundColor(textColor)
        }
    }
    
    // 日付の数字のみを取得
    private var day: Int {
        calendar.component(.day, from: date)
    }
    
    // 今日かどうかを判定
    private var isToday: Bool {
        calendar.isDateInToday(date)
    }
    
    // セルの背景色
    private var backgroundColor: Color {
        if isSelected {
            return Color.indigo.opacity(0.3)
        } else if hasEntry {
            return Color.indigo
        } else if isToday {
            return Color.gray.opacity(0.2)
        } else {
            return Color.clear
        }
    }
    
    // テキストの色
    private var textColor: Color {
        if hasEntry && !isSelected {
            return .white
        } else {
            return .primary
        }
    }
}
