import SwiftUI

struct HistoryView: View {
    @EnvironmentObject var devotionManager: DevotionManager
    
    var body: some View {
        NavigationView {
            List {
                if devotionManager.entries.isEmpty {
                    Text(NSLocalizedString("no_entries", comment: "No entries message"))
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding()
                } else {
                    ForEach(devotionManager.entries) { entry in
                        NavigationLink(destination: EntryDetailView(entry: entry)) {
                            VStack(alignment: .leading) {
                                Text(entry.date, style: .date)
                                    .font(.headline)
                                
                                Text(entry.scripture.prefix(100))
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                    .lineLimit(1)
                            }
                            .padding(.vertical, 5)
                        }
                    }
                    .onDelete(perform: deleteEntries)
                }
            }
            .navigationTitle(NSLocalizedString("history", comment: "History title"))
            .toolbar {
                EditButton()
            }
            .onAppear {
                devotionManager.loadEntries()
            }
        }
    }
    
    // エントリを削除する
    private func deleteEntries(at offsets: IndexSet) {
        for index in offsets {
            let entry = devotionManager.entries[index]
            devotionManager.deleteEntry(entry)
        }
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView()
            .environmentObject(DevotionManager())
    }
}
