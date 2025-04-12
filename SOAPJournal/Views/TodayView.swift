import SwiftUI

struct TodayView: View {
    @EnvironmentObject var devotionManager: DevotionManager
    
    @State private var scripture: String = ""
    @State private var observation: String = ""
    @State private var application: String = ""
    @State private var prayer: String = ""
    
    @State private var showingSaveConfirmation = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // 日付表示
                    HStack {
                        Text(Date(), style: .date)
                            .font(.headline)
                            .padding(.horizontal)
                        Spacer()
                    }
                    
                    // SOAPフォーム
                    SOAPInputView(
                        scripture: $scripture,
                        observation: $observation,
                        application: $application,
                        prayer: $prayer
                    )
                    
                    // 保存ボタン
                    Button(action: saveEntry) {
                        Text(NSLocalizedString("save_entry", comment: "Save entry button"))
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.indigo)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 30)
                }
                .padding(.top)
            }
            .navigationTitle(NSLocalizedString("today_devotion", comment: "Today's devotion"))
            .onAppear(perform: checkExistingEntry)
            .alert(NSLocalizedString("entry_saved", comment: "Entry saved"), isPresented: $showingSaveConfirmation) {
                Button(NSLocalizedString("ok", comment: "OK button"), role: .cancel) { }
            }
        }
    }
    
    // 今日のエントリがあれば読み込む
    private func checkExistingEntry() {
        if let entry = devotionManager.getEntryFor(date: Date()) {
            scripture = entry.scripture
            observation = entry.observation
            application = entry.application
            prayer = entry.prayer
        }
    }
    
    // エントリを保存する
    private func saveEntry() {
        devotionManager.saveEntry(
            scripture: scripture,
            observation: observation,
            application: application,
            prayer: prayer
        )
        
        showingSaveConfirmation = true
    }
}

struct TodayView_Previews: PreviewProvider {
    static var previews: some View {
        TodayView()
            .environmentObject(DevotionManager())
    }
}
