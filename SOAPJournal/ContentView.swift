import SwiftUI
import CoreData
import Combine

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    // デボーションマネージャー
    private var devotionManager: DevotionManager
    
    // 現在選択されているタブ
    @State private var selectedTab = 0
    
    // 初期化
    init() {
        // デボーションマネージャーの初期化
        let context = PersistenceController.shared.container.viewContext
        devotionManager = DevotionManager(context: context)
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // 今日のデボーションタブ
            TodayView(devotionManager: devotionManager)
                .tabItem {
                    Image(systemName: "book.fill")
                    Text(NSLocalizedString("today", comment: "Today tab"))
                }
                .tag(0)
            
            // カレンダータブ
            CalendarView(devotionManager: devotionManager)
                .tabItem {
                    Image(systemName: "calendar")
                    Text(NSLocalizedString("calendar", comment: "Calendar tab"))
                }
                .tag(1)
            
            // 履歴タブ
            HistoryView(devotionManager: devotionManager)
                .tabItem {
                    Image(systemName: "list.bullet")
                    Text(NSLocalizedString("history", comment: "History tab"))
                }
                .tag(2)
        }
        .accentColor(.blue)
        .onAppear {
            // デバイスの言語設定に基づいてローカライゼーション
            let locale = Locale.current
            print("現在のロケール: \(locale.identifier)")
            
            // CoreDataからエントリーを読み込む
            devotionManager.fetchAllEntries()
            devotionManager.fetchTodaysEntry()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
            .environment(\.locale, .init(identifier: "ja"))
    }
}