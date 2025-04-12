import SwiftUI

struct CalendarView: View {
    @EnvironmentObject var devotionManager: DevotionManager
    @State private var selectedDate: Date?
    @State private var showingDateEntry = false
    
    private let calendar = Calendar.current
    private let daysOfWeek = ["日", "月", "火", "水", "木", "金", "土"]
    private let columns = Array(repeating: GridItem(.flexible()), count: 7)
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // 月選択部分
                HStack {
                    Button(action: { devotionManager.changeMonth(by: -1) }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.indigo)
                    }
                    
                    Spacer()
                    
                    // 現在の年月表示
                    Text(month)
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Spacer()
                    
                    Button(action: { devotionManager.changeMonth(by: 1) }) {
                        Image(systemName: "chevron.right")
                            .foregroundColor(.indigo)
                    }
                }
                .padding(.horizontal)
                
                // 曜日ヘッダー
                LazyVGrid(columns: columns) {
                    ForEach(daysOfWeek, id: \.self) { day in
                        Text(day)
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(.secondary)
                            .frame(maxWidth: .infinity)
                    }
                }
                .padding(.horizontal)
                
                // カレンダーグリッド
                LazyVGrid(columns: columns, spacing: 10) {
                    ForEach(days, id: \.self) { date in
                        if let date = date {
                            CalendarDayView(
                                date: date,
                                hasEntry: hasEntry(for: date),
                                isSelected: isSelected(date)
                            )
                            .onTapGesture {
                                selectedDate = date
                                showingDateEntry = true
                            }
                        } else {
                            // 空白のセル（月の前後の日）
                            Color.clear
                                .aspectRatio(1, contentMode: .fit)
                        }
                    }
                }
                .padding(.horizontal)
                
                Spacer()
            }
            .padding(.vertical)
            .navigationTitle(NSLocalizedString("calendar", comment: "Calendar title"))
            .onAppear {
                devotionManager.updateEntriesForSelectedMonth()
            }
            .sheet(isPresented: $showingDateEntry) {
                if let date = selectedDate {
                    EntryNavigationView(date: date)
                }
            }
        }
    }
    
    // 選択された月の年月表示
    private var month: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年 M月"
        return formatter.string(from: devotionManager.currentMonth)
    }
    
    // カレンダーに表示する日付の配列
    private var days: [Date?] {
        let monthStart = startOfMonth(devotionManager.currentMonth)
        let monthEnd = endOfMonth(devotionManager.currentMonth)
        
        let firstWeekday = calendar.component(.weekday, from: monthStart) - 1
        let daysInMonth = calendar.dateComponents([.day], from: monthStart, to: monthEnd).day! + 1
        
        var days = Array(repeating: nil as Date?, count: 42)
        
        for day in 0..<daysInMonth {
            if let date = calendar.date(byAdding: .day, value: day, to: monthStart) {
                days[day + firstWeekday] = date
            }
        }
        
        return days
    }
    
    // 月の最初の日を取得
    private func startOfMonth(_ date: Date) -> Date {
        let components = calendar.dateComponents([.year, .month], from: date)
        return calendar.date(from: components)!
    }
    
    // 月の最後の日を取得
    private func endOfMonth(_ date: Date) -> Date {
        let components = calendar.dateComponents([.year, .month], from: date)
        let startOfNextMonth = calendar.date(from: DateComponents(year: components.year, month: components.month! + 1, day: 1))!
        return calendar.date(byAdding: .day, value: -1, to: startOfNextMonth)!
    }
    
    // 指定した日にエントリがあるかチェック
    private func hasEntry(for date: Date) -> Bool {
        let dateStart = calendar.startOfDay(for: date)
        return devotionManager.entriesForSelectedMonth.contains { 
            calendar.isDate($0, inSameDayAs: dateStart)
        }
    }
    
    // 日付が選択されているかチェック
    private func isSelected(_ date: Date) -> Bool {
        if let selected = selectedDate {
            return calendar.isDate(date, inSameDayAs: selected)
        }
        return false
    }
}

// 日付エントリーへのナビゲーション用ラッパー
struct EntryNavigationView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var devotionManager: DevotionManager
    
    let date: Date
    
    var body: some View {
        NavigationView {
            if let entry = devotionManager.getEntryFor(date: date) {
                EntryDetailView(entry: entry)
                    .navigationBarItems(trailing: Button(NSLocalizedString("close", comment: "Close button")) {
                        presentationMode.wrappedValue.dismiss()
                    })
            } else {
                Text(NSLocalizedString("no_entry_for_date", comment: "No entry for this date"))
                    .navigationBarItems(trailing: Button(NSLocalizedString("close", comment: "Close button")) {
                        presentationMode.wrappedValue.dismiss()
                    })
            }
        }
    }
}

struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView()
            .environmentObject(DevotionManager())
    }
}
