import SwiftUI

struct TodayView: View {
    @ObservedObject var devotionManager: DevotionManager
    
    @State private var scripture: String = ""
    @State private var observation: String = ""
    @State private var application: String = ""
    @State private var prayerCompleted: Bool = false
    
    @State private var showingSavedAlert = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // タイトル
                Text(NSLocalizedString("today_devotion", comment: "Today's devotion title"))
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(Color("Colors/PrimaryBrown"))
                    .padding(.top)
                
                // 今日の日付
                Text(Date().displayString)
                    .font(.headline)
                    .foregroundColor(Color("Colors/PrimaryBrown").opacity(0.8))
                
                // SOAPフォーム
                SOAPInputView(
                    scripture: $scripture,
                    observation: $observation,
                    application: $application,
                    prayerCompleted: $prayerCompleted
                )
                
                // 保存ボタン
                Button(action: saveEntry) {
                    Text(NSLocalizedString("save_entry", comment: "Save button"))
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color("Colors/PrimaryBrown"))
                        .cornerRadius(10)
                }
                .padding(.top)
            }
            .padding()
        }
        .onAppear(perform: loadTodaysEntry)
        .alert(isPresented: $showingSavedAlert) {
            Alert(
                title: Text(NSLocalizedString("entry_saved", comment: "Entry saved alert title")),
                dismissButton: .default(Text(NSLocalizedString("ok", comment: "OK button")))
            )
        }
    }
    
    private func loadTodaysEntry() {
        if let entry = devotionManager.todaysEntry {
            scripture = entry.scripture
            observation = entry.observation
            application = entry.application
            prayerCompleted = entry.prayerCompleted
        } else {
            // 今日のエントリーがない場合は空の状態にする
            scripture = ""
            observation = ""
            application = ""
            prayerCompleted = false
        }
    }
    
    private func saveEntry() {
        devotionManager.createEntry(
            scripture: scripture,
            observation: observation,
            application: application,
            prayerCompleted: prayerCompleted
        )
        
        showingSavedAlert = true
    }
}

struct TodayView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        TodayView(devotionManager: DevotionManager(context: context))
    }
}