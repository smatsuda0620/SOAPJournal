import SwiftUI

struct TodayView: View {
    @ObservedObject var devotionManager: DevotionManager
    
    @State private var scripture: String = ""
    @State private var observation: String = ""
    @State private var application: String = ""
    @State private var prayerCompleted: Bool = false
    
    @State private var showingSavedAlert = false
    
    // UIApplicationを使ってキーボードを閉じるために必要
    @State private var isInputActive: Bool = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) { // スペースを20から12に縮小
                // 画面全体をタップ可能にして、入力欄以外タップでキーボードを閉じる
                Rectangle()
                    .foregroundColor(.clear)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        isInputActive = false
                        hideKeyboard() // キーボードを非表示にする
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .ignoresSafeArea()
                ZStack(alignment: .topLeading) {
                    // ヘッダーの背景
                    Rectangle()
                        .fill(Color("BackgroundCream"))
                        .frame(height: 100)
                        .cornerRadius(12)
                        .padding(.horizontal, 16) // 背景にもパディングを追加して他の要素と揃える
                    
                    VStack(alignment: .leading, spacing: 8) {
                        // タイトル
                        Text(NSLocalizedString("today_devotion", comment: "Today's devotion title"))
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(Color("PrimaryBrown"))
                            .padding(.top, 16) // 上部パディングを16に増やす
                        
                        // 今日の日付
                        Text(Date().displayString)
                            .font(.headline)
                            .foregroundColor(Color("PrimaryBrown").opacity(0.8))
                            .padding(.bottom, 16) // 下部パディングも16に設定
                    }
                    .padding(.horizontal, 32) // 内側のパディングを増やす（外側16 + 内側16 = 32）
                }
                .padding(.bottom, 4) // 下のパディングを8から4に縮小
                
                // SOAPフォーム（祈りが完了していたら閲覧モード、そうでなければ編集モード）
                if prayerCompleted {
                    // 閲覧モード（祈りが完了している場合）
                    VStack(alignment: .leading, spacing: 16) {
                        // 聖句セクション
                        displaySection(title: NSLocalizedString("scripture", comment: "Scripture section title"), content: scripture)
                        
                        // 観察セクション
                        displaySection(title: NSLocalizedString("observation", comment: "Observation section title"), content: observation)
                        
                        // 適用セクション
                        displaySection(title: NSLocalizedString("application", comment: "Application section title"), content: application)
                        
                        // 祈りセクション
                        VStack(alignment: .leading, spacing: 8) {
                            Text(NSLocalizedString("prayer", comment: "Prayer section title"))
                                .font(.headline)
                                .foregroundColor(Color("PrimaryBrown"))
                            
                            Text("祈りを完了しました")
                                .foregroundColor(Color("PrimaryBrown"))
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(Color("BackgroundCream"))
                                )
                        }
                    }
                    .padding(.horizontal, 16)
                } else {
                    // 編集モード（祈りが完了していない場合）
                    SOAPInputView(
                        scripture: $scripture,
                        observation: $observation,
                        application: $application,
                        prayerCompleted: $prayerCompleted,
                        isInputActive: $isInputActive
                    )
                    .environmentObject(devotionManager)
                }
                
                // 保存ボタンを削除 - 祈りの完了時に自動的に保存
            }
            .padding(.vertical, 12) // 垂直方向のパディングは12に
            .padding(.horizontal, 16) // 水平方向のパディングを16に統一
        }
        .onAppear(perform: loadTodaysEntry)
        .alert(isPresented: $showingSavedAlert) {
            Alert(
                title: Text(NSLocalizedString("entry_saved", comment: "Entry saved alert title")),
                message: Text(NSLocalizedString("devotion_saved_message", comment: "Your devotion has been saved")),
                dismissButton: .default(Text(NSLocalizedString("ok", comment: "OK button")))
            )
        }
    }
    
    private func loadTodaysEntry() {
        // 確実に最新のエントリーを取得
        devotionManager.fetchTodaysEntry()
        
        if let entry = devotionManager.todaysEntry {
            scripture = entry.scripture
            observation = entry.observation
            application = entry.application
            
            // デボーション実績がある場合は表示モードを維持（固定値表示）
            // エントリーが存在するだけで祈り完了扱いにして編集できないようにする
            prayerCompleted = true
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
        
        // 保存後、再度状態を更新
        loadTodaysEntry()
        
        showingSavedAlert = true
    }
    
    // 閲覧モード用のセクション表示関数
    private func displaySection(title: String, content: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
                .foregroundColor(Color("PrimaryBrown"))
                .frame(maxWidth: .infinity, alignment: .leading)
                
            Text(content.isEmpty ? "未入力" : content)
                .font(.body)
                .foregroundColor(.primary)
                .fixedSize(horizontal: false, vertical: true)
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color("BackgroundCream"))
                )
                .multilineTextAlignment(.leading)
        }
    }
    
    // キーボードを非表示にするヘルパー関数
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct TodayView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        TodayView(devotionManager: DevotionManager(context: context))
    }
}