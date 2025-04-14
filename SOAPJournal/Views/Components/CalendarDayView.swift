import SwiftUI

struct CalendarDayView: View {
    var day: Int
    var isToday: Bool
    var hasEntry: Bool
    var isCurrentMonth: Bool
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            // 日付テキスト
            Text("\(day)")
                .font(isToday ? .headline : .body)
                .foregroundColor(textColor)
                .frame(width: 35, height: 35)
                .background(
                    Circle()
                        .fill(backgroundFillColor)
                        .overlay(
                            Circle()
                                .stroke(isToday ? Color("PrimaryBrown") : Color.clear, lineWidth: 1.5)
                        )
                )
        }
        .disabled(!isCurrentMonth)
    }
    
    // テキストの色を決定
    private var textColor: Color {
        if !isCurrentMonth {
            return Color.gray.opacity(0.5)
        } else if isToday || hasEntry {
            return Color.white
        } else {
            return Color.primary
        }
    }
    
    // 背景色を決定
    private var backgroundFillColor: Color {
        if !isCurrentMonth {
            return Color.clear
        } else if isToday {
            return Color("PrimaryBrown").opacity(0.7)
        } else if hasEntry {
            return Color("PrimaryBrown")
        } else {
            return Color.clear
        }
    }
}

struct CalendarDayView_Previews: PreviewProvider {
    static var previews: some View {
        HStack {
            // 通常の日
            CalendarDayView(
                day: 15,
                isToday: false,
                hasEntry: false,
                isCurrentMonth: true,
                action: {}
            )
            
            // 今日
            CalendarDayView(
                day: 16,
                isToday: true,
                hasEntry: false,
                isCurrentMonth: true,
                action: {}
            )
            
            // エントリーのある日
            CalendarDayView(
                day: 17,
                isToday: false,
                hasEntry: true,
                isCurrentMonth: true,
                action: {}
            )
            
            // 今日でエントリーのある日
            CalendarDayView(
                day: 18,
                isToday: true,
                hasEntry: true,
                isCurrentMonth: true,
                action: {}
            )
            
            // 前月または次月の日
            CalendarDayView(
                day: 3,
                isToday: false,
                hasEntry: false,
                isCurrentMonth: false,
                action: {}
            )
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}