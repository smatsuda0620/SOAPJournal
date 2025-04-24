import SwiftUI

struct CalendarView: View {
    @ObservedObject var devotionManager: DevotionManager
    @State private var selectedMonth: Date = Date()
    @State private var selectedDate: Date?
    @State private var showingEntryDetail = false
    
    private let calendar = Calendar.current
    private let weekdaySymbols = Calendar.current.shortWeekdaySymbols
    
    var body: some View {
        VStack {
            // カレンダーヘッダー（月表示と月切り替えボタン）
            HStack {
                Button(action: { moveMonth(by: -1) }) {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                        .foregroundColor(Color("PrimaryBrown"))
                }
                
                Spacer()
                
                Text(DateFormatter.monthFormatter.string(from: selectedMonth))
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(Color("PrimaryBrown"))
                
                Spacer()
                
                Button(action: { moveMonth(by: 1) }) {
                    Image(systemName: "chevron.right")
                        .font(.title2)
                        .foregroundColor(Color("PrimaryBrown"))
                }
            }
            .padding(.horizontal)
            .padding(.top)
            
            // 曜日ヘッダー
            HStack {
                ForEach(weekdaySymbols, id: \.self) { symbol in
                    Text(symbol)
                        .frame(maxWidth: .infinity)
                        .foregroundColor(Color("PrimaryBrown").opacity(0.7))
                        .fontWeight(.medium)
                }
            }
            .padding(.top, 8)
            
            // カレンダーグリッド
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 10) {
                ForEach(0..<calendarDays().count, id: \.self) { index in
                    let dateOpt = calendarDays()[index]
                    if let date = dateOpt {
                        let day = calendar.component(.day, from: date)
                        let isToday = calendar.isDateInToday(date)
                        let hasEntry = hasEntry(for: date)
                        let isCurrentMonth = date.isSameMonth(as: selectedMonth)
                        
                        CalendarDayView(
                            day: day,
                            isToday: isToday,
                            hasEntry: hasEntry,
                            isCurrentMonth: isCurrentMonth
                        ) {
                            selectedDate = date
                            showingEntryDetail = true
                        }
                    } else {
                        // 空のセル（カレンダーグリッドの空白部分）
                        Color.clear
                            .frame(width: 35, height: 35)
                    }
                }
            }
            .padding(.horizontal)
            
            Spacer()
        }
        .navigationTitle(NSLocalizedString("calendar", comment: "Calendar tab title"))
        .onAppear {
            // デバイスの設定に応じて日付を更新
            selectedMonth = Date()
            devotionManager.fetchAllEntries()
        }
        .onChange(of: showingEntryDetail) { isShowing in
            if isShowing {
                // シートが表示されるタイミングでエントリーを再取得
                if let date = selectedDate {
                    // エントリーを確実に取得するために少し待機
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        // エントリー情報を確実に更新
                        devotionManager.fetchAllEntries()
                    }
                }
            }
        }
        .sheet(isPresented: $showingEntryDetail) {
            if let selectedDate = selectedDate {
                if let entry = devotionManager.fetchEntry(for: selectedDate) {
                    EntryDetailView(entry: entry, devotionManager: devotionManager)
                } else {
                    VStack {
                        Text(NSLocalizedString("no_entry_for_date", comment: "No entry for this date"))
                            .font(.headline)
                            .foregroundColor(Color("PrimaryBrown"))
                            .padding()
                        
                        Button(NSLocalizedString("close", comment: "Close button")) {
                            showingEntryDetail = false
                        }
                        .foregroundColor(Color("PrimaryBrown"))
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color("PrimaryBrown"), lineWidth: 1)
                        )
                        .padding()
                    }
                    .frame(maxWidth: .infinity, maxHeight: 200)
                    .background(Color("BackgroundCream"))
                    .cornerRadius(12)
                }
            }
        }
    }
    
    // 指定された月のカレンダー日を生成
    private func calendarDays() -> [Date?] {
        guard let monthInterval = calendar.dateInterval(of: .month, for: selectedMonth) else {
            return []
        }
        
        let firstDay = monthInterval.start
        let lastDay = calendar.date(byAdding: DateComponents(day: -1), to: monthInterval.end)!
        
        let firstWeekday = calendar.component(.weekday, from: firstDay)
        let numDaysInMonth = calendar.dateComponents([.day], from: monthInterval.start, to: monthInterval.end).day!
        
        var days: [Date?] = []
        
        // 月の最初の日より前の空セル
        for _ in 1..<firstWeekday {
            days.append(nil)
        }
        
        // 月の日付
        for day in 1...numDaysInMonth {
            let date = calendar.date(byAdding: .day, value: day - 1, to: firstDay)
            days.append(date)
        }
        
        // セルの総数を7の倍数に調整（週の完全な行を形成するため）
        let remainder = (days.count % 7)
        if remainder > 0 {
            for _ in 0..<(7 - remainder) {
                days.append(nil)
            }
        }
        
        return days
    }
    
    // 月を移動
    private func moveMonth(by numberOfMonths: Int) {
        if let newMonth = calendar.date(byAdding: .month, value: numberOfMonths, to: selectedMonth) {
            selectedMonth = newMonth
        }
    }
    
    // 特定の日にエントリーがあるかをチェック
    private func hasEntry(for date: Date) -> Bool {
        return devotionManager.fetchEntry(for: date) != nil
    }
}

struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        CalendarView(devotionManager: DevotionManager(context: context))
    }
}