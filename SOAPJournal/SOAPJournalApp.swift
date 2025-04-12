import SwiftUI

@main
struct SOAPJournalApp: App {
    @StateObject private var devotionManager = DevotionManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(devotionManager)
                .onAppear {
                    // アプリ起動時にデータを読み込む
                    devotionManager.loadEntries()
                }
        }
    }
}
