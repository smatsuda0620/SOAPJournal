import Foundation
import CoreData
import SwiftUI

class DevotionManager: ObservableObject {
    // CoreDataのコンテキスト
    private let viewContext: NSManagedObjectContext
    
    // 今日のエントリー
    @Published var todaysEntry: DevotionEntry?
    
    // 全てのエントリー（最新順）
    @Published var allEntries: [DevotionEntry] = []
    
    // 初期化
    init(context: NSManagedObjectContext) {
        self.viewContext = context
        fetchAllEntries()
        fetchTodaysEntry()
    }
    
    // すべてのエントリーを取得
    func fetchAllEntries() {
        let request = DevotionEntry.fetchAllSortedByDateRequest()
        
        do {
            allEntries = try viewContext.fetch(request)
        } catch {
            print("Error fetching all entries: \(error)")
        }
    }
    
    // 特定の日のエントリーを取得
    func fetchEntry(for date: Date) -> DevotionEntry? {
        let request = DevotionEntry.fetchRequest(for: date)
        
        do {
            let entries = try viewContext.fetch(request)
            return entries.first
        } catch {
            print("Error fetching entry for date \(date): \(error)")
            return nil
        }
    }
    
    // 今日のエントリーを取得
    func fetchTodaysEntry() {
        todaysEntry = fetchEntry(for: Date())
    }
    
    // 新しいエントリーを作成
    func createEntry(scripture: String, observation: String, application: String, prayerCompleted: Bool = false, date: Date = Date()) {
        // もし同じ日のエントリーがすでに存在する場合は更新する
        if let existingEntry = fetchEntry(for: date) {
            updateEntry(existingEntry, scripture: scripture, observation: observation, application: application, prayerCompleted: prayerCompleted)
            return
        }
        
        // 新しいエントリーを作成
        _ = DevotionEntry.create(
            in: viewContext,
            date: date,
            scripture: scripture,
            observation: observation, 
            application: application,
            prayerCompleted: prayerCompleted
        )
        
        saveContext()
        fetchAllEntries()
        fetchTodaysEntry()
    }
    
    // エントリーを更新
    func updateEntry(_ entry: DevotionEntry, scripture: String, observation: String, application: String, prayerCompleted: Bool) {
        entry.scripture = scripture
        entry.observation = observation
        entry.application = application
        entry.prayerCompleted = prayerCompleted
        
        saveContext()
        fetchAllEntries()
        fetchTodaysEntry()
    }
    
    // エントリーを削除
    func deleteEntry(_ entry: DevotionEntry) {
        viewContext.delete(entry)
        
        saveContext()
        fetchAllEntries()
        fetchTodaysEntry()
    }
    
    // コンテキストを保存
    private func saveContext() {
        do {
            try viewContext.save()
        } catch {
            print("Error saving context: \(error)")
        }
    }
}