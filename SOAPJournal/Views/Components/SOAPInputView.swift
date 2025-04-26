import SwiftUI

struct SOAPInputView: View {
    @Binding var scripture: String
    @Binding var observation: String
    @Binding var application: String
    @Binding var prayerCompleted: Bool
    @Binding var isInputActive: Bool
    
    @State private var showingPrayerTimer = false
    @State private var showingSavedAlert = false
    @State private var showingClipboardAlert = false
    @State private var clipboardText: String = ""
    
    // 各セクションのフォーカス状態
    @State private var isScriptureFocused: Bool = false
    @State private var isObservationFocused: Bool = false
    @State private var isApplicationFocused: Bool = false
    
    // DevotionManagerを環境変数から取得
    @EnvironmentObject var devotionManager: DevotionManager
    
    // SOAPの入力が有効かどうかを判定する計算プロパティ
    private var isSOAPInputValid: Bool {
        !scripture.isEmpty && !observation.isEmpty && !application.isEmpty
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) { // スペースを16から12に縮小
            
            sectionView(
                title: NSLocalizedString("scripture", comment: "Scripture section title"),
                text: $scripture,
                placeholder: NSLocalizedString("scripture_placeholder", comment: "Scripture input placeholder"),
                isScripture: true // 聖句入力欄を識別するためのフラグ
            )
            
            sectionView(
                title: NSLocalizedString("observation", comment: "Observation section title"),
                text: $observation,
                placeholder: NSLocalizedString("observation_placeholder", comment: "Observation input placeholder")
            )
            
            sectionView(
                title: NSLocalizedString("application", comment: "Application section title"),
                text: $application,
                placeholder: NSLocalizedString("application_placeholder", comment: "Application input placeholder")
            )
            
            // 祈りセクション（タイマーボタンを表示）
            VStack(alignment: .leading, spacing: 8) {
                Text(NSLocalizedString("prayer", comment: "Prayer section title"))
                    .font(.headline)
                    .foregroundColor(Color("PrimaryBrown"))
                
                if prayerCompleted {
                    HStack {
                        Text("祈りを完了しました")
                            .foregroundColor(Color("PrimaryBrown"))
                            .padding()
                            .background(Color("BackgroundCream"))
                            .cornerRadius(8)
                        
                        Spacer()
                        
                        // リセットボタン
                        Button(action: {
                            prayerCompleted = false
                        }) {
                            Image(systemName: "arrow.counterclockwise")
                                .foregroundColor(Color("PrimaryBrown"))
                        }
                    }
                } else {
                    Button(action: {
                        showingPrayerTimer = true
                    }) {
                        Text(NSLocalizedString("start_prayer", comment: "Start prayer button"))
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(isSOAPInputValid ? Color("PrimaryBrown") : Color.gray)
                            .cornerRadius(8)
                    }
                    .disabled(!isSOAPInputValid)
                }
            }
        }
        .padding(.horizontal, 16) // 水平方向のパディングを16に固定（ヘッダーと揃える）
        .sheet(isPresented: $showingPrayerTimer) {
            PrayerTimerView(prayerCompleted: $prayerCompleted)
        }
        // 各テキストフィールドの変更を監視して自動保存
        .onChange(of: scripture) { _ in saveIfValid() }
        .onChange(of: observation) { _ in saveIfValid() }
        .onChange(of: application) { _ in saveIfValid() }
        .onChange(of: prayerCompleted) { completed in
            if completed {
                // 祈りが完了したら自動保存
                saveEntry()
            } else {
                // 祈りを取り消した場合も保存
                saveIfValid()
            }
        }
        .alert(isPresented: $showingSavedAlert) {
            Alert(
                title: Text(NSLocalizedString("entry_saved", comment: "Entry saved alert title")),
                message: Text(NSLocalizedString("devotion_saved_message", comment: "Your devotion has been saved")),
                dismissButton: .default(Text(NSLocalizedString("ok", comment: "OK button")))
            )
        }
        .alert("クリップボードのテキストを聖句に入力しますか？", isPresented: $showingClipboardAlert) {
            Button("はい") {
                scripture = clipboardText
                isScriptureFocused = true
            }
            Button("いいえ") {
                isScriptureFocused = true
            }
        } message: {
            Text("クリップボードに以下のテキストがあります：\n\n\(clipboardText)")
        }
        .onAppear {
            checkClipboardForScripture()
        }
    }
    
    private func sectionView(title: String, text: Binding<String>, placeholder: String, isScripture: Bool = false) -> some View {
        VStack(alignment: .leading, spacing: 2) { // スペーシングを明示的に2にする（タイトルと入力フィールドの間を狭く）
            Text(title)
                .font(.headline)
                .foregroundColor(Color("PrimaryBrown"))
                .padding(.bottom, 2) // 4から2に縮小
            
            ZStack {
                TextEditor(text: text)
                    .frame(minHeight: 80)
                    .padding(8)
                    // フォーカス状態を設定
                    .onTapGesture {
                        if title == NSLocalizedString("scripture", comment: "Scripture section title") {
                            isScriptureFocused = true
                            isObservationFocused = false
                            isApplicationFocused = false
                        } else if title == NSLocalizedString("observation", comment: "Observation section title") {
                            isScriptureFocused = false
                            isObservationFocused = true
                            isApplicationFocused = false
                        } else if title == NSLocalizedString("application", comment: "Application section title") {
                            isScriptureFocused = false
                            isObservationFocused = false
                            isApplicationFocused = true
                        }
                    }
                    // 親ビューのフォーカス状態と連動
                    .onChange(of: isInputActive) { active in
                        if !active {
                            isScriptureFocused = false
                            isObservationFocused = false
                            isApplicationFocused = false
                        }
                    }
                    // ScrollViewのバウンスを無効化
                    .onAppear {
                        UITextView.appearance().bounces = false
                    }
            }
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color("PrimaryBrown").opacity(0.3), lineWidth: 1)
                    .background(Color("BackgroundCream").cornerRadius(8))
            )
                .overlay(
                    Group {
                        if text.wrappedValue.isEmpty {
                            Text(placeholder)
                                .foregroundColor(Color("PrimaryBrown").opacity(0.5))
                                .padding(12)
                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                                .allowsHitTesting(false)
                        }
                    }, alignment: .center
                )
        }
    }
}

extension SOAPInputView {
    // 入力が有効な場合のみ保存
    private func saveIfValid() {
        if !scripture.isEmpty || !observation.isEmpty || !application.isEmpty {
            devotionManager.createEntry(
                scripture: scripture,
                observation: observation,
                application: application,
                prayerCompleted: prayerCompleted
            )
            // 自動保存時は通知を表示しない
        }
    }
    
    // エントリーを保存する関数
    private func saveEntry() {
        devotionManager.createEntry(
            scripture: scripture,
            observation: observation,
            application: application,
            prayerCompleted: prayerCompleted
        )
        
        showingSavedAlert = true
    }
    
    // クリップボードの内容を確認し、聖句入力に使えるかどうかをチェック
    private func checkClipboardForScripture() {
        // すでに聖句が入力されている場合はスキップ
        if !scripture.isEmpty {
            return
        }
        
        // クリップボードの内容を取得
        if let clipboardString = UIPasteboard.general.string, !clipboardString.isEmpty {
            // 空でなければクリップボードの内容を保存
            clipboardText = clipboardString
            
            // 一定の文字数以内であれば聖句として使用を提案
            if clipboardString.count < 500 {
                // ビューがロードされた後に少し遅らせてアラートを表示
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.showingClipboardAlert = true
                }
            }
        }
    }
}

struct SOAPInputView_Previews: PreviewProvider {
    static var previews: some View {
        SOAPInputView(
            scripture: .constant(""),
            observation: .constant(""),
            application: .constant(""),
            prayerCompleted: .constant(false),
            isInputActive: .constant(false)
        )
        .environmentObject(DevotionManager(context: PersistenceController.preview.container.viewContext))
    }
}