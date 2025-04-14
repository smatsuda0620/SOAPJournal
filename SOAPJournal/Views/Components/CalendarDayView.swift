import SwiftUI

struct CalendarDayView: View {
    var day: Int
    var isToday: Bool
    var hasEntry: Bool
    var isCurrentMonth: Bool
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack {
                // 日付テキスト
                Text("\(day)")
                    .font(isToday ? .headline : .body)
                    .foregroundColor(textColor)
                
                // エントリーの有無を表すインジケーター
                if hasEntry {
                    Circle()
                        .fill(Color("Colors/PrimaryBrown"))
                        .frame(width: 8, height: 8)
                }
            }
            .frame(width: 35, height: 35)
            .background(
                Circle()
                    .fill(isToday ? Color("Colors/BackgroundCream") : Color.clear)
                    .overlay(
                        Circle()
                            .stroke(isToday ? Color("Colors/PrimaryBrown") : Color.clear, lineWidth: 1.5)
                    )
            )
        }
        .disabled(!isCurrentMonth)
    }
    
    // テキストの色を決定
    private var textColor: Color {
        if !isCurrentMonth {
            return Color.gray.opacity(0.5)
        } else if isToday {
            return Color("Colors/PrimaryBrown")
        } else {
            return Color.primary
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