import SwiftUI

struct EntryDetailView: View {
    let entry: DevotionEntry
    let devotionManager: DevotionManager
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        // 画面全体をタップ可能にし、タップで閉じられるようにする
        ZStack {
            // 背景も含めた全画面タップで閉じる
            Color.clear
                .contentShape(Rectangle())
                .onTapGesture {
                    presentationMode.wrappedValue.dismiss()
                }
            
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    // ヘッダー部分（日付表示のみ）
                    HStack {
                        Text(entry.date.displayString)
                            .font(.headline)
                            .foregroundColor(Color("PrimaryBrown"))
                        
                        Spacer()
                        
                        // 閉じるボタン
                        Button(action: { presentationMode.wrappedValue.dismiss() }) {
                            Image(systemName: "xmark.circle")
                                .foregroundColor(Color("PrimaryBrown"))
                                .font(.title3)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top)
                    
                    // 閲覧モード（編集機能を完全に削除）
                    VStack(alignment: .leading, spacing: 20) {
                        // 各セクション表示（ボタン動作を削除）- 祈りは表示しない
                        sectionView(title: NSLocalizedString("scripture", comment: "Scripture section"), content: entry.scripture)
                        sectionView(title: NSLocalizedString("observation", comment: "Observation section"), content: entry.observation)
                        sectionView(title: NSLocalizedString("application", comment: "Application section"), content: entry.application)
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
                .foregroundColor(Color("PrimaryBrown"))
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text(content)
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
}

struct EntryDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        let entry = DevotionEntry.create(
            in: context,
            scripture: "ヨハネ3:16",
            observation: "神は世を愛されました...",
            application: "神の愛を思い出すことで...",
            prayerCompleted: true
        )
        
        return EntryDetailView(
            entry: entry,
            devotionManager: DevotionManager(context: context)
        )
    }
}