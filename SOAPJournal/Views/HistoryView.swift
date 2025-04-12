import SwiftUI

struct HistoryView: View {
    @ObservedObject var devotionManager: DevotionManager
    @State private var selectedEntry: DevotionEntry?
    @State private var showingDetail = false
    
    var body: some View {
        NavigationView {
            Group {
                if devotionManager.allEntries.isEmpty {
                    // 記録がない場合の表示
                    VStack {
                        Text(NSLocalizedString("no_entries", comment: "No entries message"))
                            .font(.headline)
                            .foregroundColor(.secondary)
                            .padding()
                        
                        Spacer()
                    }
                } else {
                    // エントリー一覧
                    List {
                        ForEach(devotionManager.allEntries, id: \.id) { entry in
                            entryRow(for: entry)
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    selectedEntry = entry
                                    showingDetail = true
                                }
                        }
                    }
                }
            }
            .navigationTitle(NSLocalizedString("history", comment: "History tab title"))
            .onAppear {
                devotionManager.fetchAllEntries()
            }
            .sheet(isPresented: $showingDetail) {
                if let entry = selectedEntry {
                    EntryDetailView(entry: entry, devotionManager: devotionManager)
                }
            }
        }
    }
    
    // 各エントリーの行表示
    private func entryRow(for entry: DevotionEntry) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                // 日付
                Text(entry.date.displayString)
                    .font(.headline)
                
                Spacer()
                
                // 今日の場合は「今日」のバッジを表示
                if entry.date.isToday {
                    Text(NSLocalizedString("today", comment: "Today badge"))
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
            
            // 聖句の一部を表示（プレビュー）
            if !entry.scripture.isEmpty {
                Text(entry.scripture)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                    .truncationMode(.tail)
                    .padding(.top, 4)
            }
            
            // 聖句から先のコンテンツ有無のインジケーター
            HStack {
                if !entry.observation.isEmpty {
                    categoryIndicator(title: "O")
                }
                
                if !entry.application.isEmpty {
                    categoryIndicator(title: "A")
                }
                
                if !entry.prayer.isEmpty {
                    categoryIndicator(title: "P")
                }
                
                Spacer()
            }
            .padding(.top, 4)
        }
        .padding(.vertical, 8)
    }
    
    // カテゴリーのインジケーター（O/A/P）
    private func categoryIndicator(title: String) -> some View {
        Text(title)
            .font(.caption)
            .fontWeight(.bold)
            .padding(.horizontal, 6)
            .padding(.vertical, 2)
            .background(
                Circle()
                    .fill(Color.gray.opacity(0.2))
            )
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        HistoryView(devotionManager: DevotionManager(context: context))
    }
}