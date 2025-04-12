import SwiftUI

struct ContentView: View {
    @EnvironmentObject var devotionManager: DevotionManager
    
    var body: some View {
        TabView {
            TodayView()
                .tabItem {
                    Label(NSLocalizedString("today", comment: "Today tab"), systemImage: "book.fill")
                }
            
            CalendarView()
                .tabItem {
                    Label(NSLocalizedString("calendar", comment: "Calendar tab"), systemImage: "calendar")
                }
            
            HistoryView()
                .tabItem {
                    Label(NSLocalizedString("history", comment: "History tab"), systemImage: "list.bullet")
                }
        }
        .accentColor(.indigo)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(DevotionManager())
    }
}
