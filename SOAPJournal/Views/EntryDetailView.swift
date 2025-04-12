import SwiftUI

struct EntryDetailView: View {
    let entry: DevotionEntry
    let devotionManager: DevotionManager
    
    @State private var isEditing = false
    @State private var scripture: String
    @State private var observation: String
    @State private var application: String
    @State private var prayer: String
    
    @Environment(\.presentationMode) var presentationMode
    
    init(entry: DevotionEntry, devotionManager: DevotionManager) {
        self.entry = entry
        self.devotionManager = devotionManager
        
        // 初期値を設定
        _scripture = State(initialValue: entry.scripture)
        _observation = State(initialValue: entry.observation)
        _application = State(initialValue: entry.application)
        _prayer = State(initialValue: entry.prayer)
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // ヘッダー部分（日付と編集ボタン）
                HStack {
                    Text(entry.date.displayString)
                        .font(.headline)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    if isEditing {
                        Button(NSLocalizedString("cancel", comment: "Cancel button")) {
                            // 編集をキャンセルして元の値に戻す
                            isEditing = false
                            resetValues()
                        }
                    } else {
                        Button(NSLocalizedString("edit", comment: "Edit button")) {
                            isEditing = true
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.top)
                
                if isEditing {
                    // 編集モード
                    SOAPInputView(
                        scripture: $scripture,
                        observation: $observation,
                        application: $application,
                        prayer: $prayer
                    )
                    
                    // 保存ボタン
                    Button(action: saveChanges) {
                        Text(NSLocalizedString("save_changes", comment: "Save changes button"))
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)
                    .padding(.bottom)
                    
                    // 削除ボタン
                    Button(action: deleteEntry) {
                        Text(NSLocalizedString("delete", comment: "Delete button"))
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.red)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)
                    .padding(.bottom)
                } else {
                    // 閲覧モード
                    VStack(alignment: .leading, spacing: 20) {
                        sectionView(title: NSLocalizedString("scripture", comment: "Scripture section"), content: entry.scripture)
                        sectionView(title: NSLocalizedString("observation", comment: "Observation section"), content: entry.observation)
                        sectionView(title: NSLocalizedString("application", comment: "Application section"), content: entry.application)
                        sectionView(title: NSLocalizedString("prayer", comment: "Prayer section"), content: entry.prayer)
                    }
                    .padding()
                }
            }
        }
    }
    
    // セクションを表示するヘルパービュー
    private func sectionView(title: String, content: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
                .foregroundColor(.primary)
            
            Text(content)
                .font(.body)
                .foregroundColor(.primary)
                .fixedSize(horizontal: false, vertical: true)
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.gray.opacity(0.1))
                )
        }
    }
    
    // エントリーの変更を保存
    private func saveChanges() {
        devotionManager.updateEntry(
            entry,
            scripture: scripture,
            observation: observation,
            application: application,
            prayer: prayer
        )
        
        isEditing = false
    }
    
    // エントリーを削除
    private func deleteEntry() {
        devotionManager.deleteEntry(entry)
        presentationMode.wrappedValue.dismiss()
    }
    
    // 編集をキャンセルして元の値に戻す
    private func resetValues() {
        scripture = entry.scripture
        observation = entry.observation
        application = entry.application
        prayer = entry.prayer
    }
}

struct EntryDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        let entry = DevotionEntry.create(
            in: context,
            scripture: "ヨハネ3:16",
            observation: "神は世を愛されました...",
            application: "神の愛を思い出すことで...",
            prayer: "主よ、あなたの素晴らしい愛に感謝します..."
        )
        
        return EntryDetailView(
            entry: entry,
            devotionManager: DevotionManager(context: context)
        )
    }
}