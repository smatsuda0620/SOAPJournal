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
                        Spacer()
                        
                        VStack(spacing: 20) {
                            Image(systemName: "book.closed")
                                .font(.system(size: 60))
                                .foregroundColor(Color("Colors/PrimaryBrown").opacity(0.7))
                            
                            Text(NSLocalizedString("no_entries", comment: "No entries message"))
                                .font(.headline)
                                .foregroundColor(Color("Colors/PrimaryBrown"))
                        }
                        .padding(40)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color("Colors/BackgroundCream"))
                        )
                        
                        Spacer()
                    }
                    .frame(maxWidth: .infinity)
                    .background(Color.white)
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
                                .listRowSeparator(.hidden)
                                .listRowBackground(Color.clear)
                        }
                    }
                    .listStyle(PlainListStyle())
                    .background(Color("Colors/BackgroundCream").opacity(0.5))
                }
            }
            .navigationTitle(NSLocalizedString("history", comment: "History tab title"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(NSLocalizedString("history", comment: "History tab title"))
                        .font(.headline)
                        .foregroundColor(Color("Colors/PrimaryBrown"))
                }
            }
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
                    .foregroundColor(Color("Colors/PrimaryBrown"))
                
                Spacer()
                
                // 今日の場合は「今日」のバッジを表示
                if entry.date.isToday {
                    Text(NSLocalizedString("today", comment: "Today badge"))
                        .font(.caption)
                        .fontWeight(.bold)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color("Colors/PrimaryBrown"))
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
            
            // 聖句の一部を表示（プレビュー）
            if !entry.scripture.isEmpty {
                Text(entry.scripture)
                    .font(.subheadline)
                    .foregroundColor(Color.primary.opacity(0.7))
                    .lineLimit(2)
                    .truncationMode(.tail)
                    .padding(.top, 4)
                    .padding(.horizontal, 4)
            }
            
            // 聖句から先のコンテンツ有無のインジケーター
            HStack {
                if !entry.observation.isEmpty {
                    categoryIndicator(title: "O")
                }
                
                if !entry.application.isEmpty {
                    categoryIndicator(title: "A")
                }
                
                if entry.prayerCompleted {
                    categoryIndicator(title: "P")
                }
                
                Spacer()
            }
            .padding(.top, 4)
        }
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.05), radius: 3, x: 0, y: 1)
        )
        .padding(.horizontal, 4)
        .padding(.vertical, 4)
    }
    
    // カテゴリーのインジケーター（O/A/P）
    private func categoryIndicator(title: String) -> some View {
        Text(title)
            .font(.caption)
            .fontWeight(.bold)
            .foregroundColor(Color("Colors/PrimaryBrown"))
            .padding(.horizontal, 6)
            .padding(.vertical, 2)
            .background(
                Circle()
                    .fill(Color("Colors/BackgroundCream"))
                    .overlay(
                        Circle()
                            .stroke(Color("Colors/PrimaryBrown").opacity(0.3), lineWidth: 1)
                    )
            )
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        HistoryView(devotionManager: DevotionManager(context: context))
    }
}