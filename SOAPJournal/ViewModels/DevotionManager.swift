import Foundation
import CoreData
import SwiftUI

class DevotionManager: ObservableObject {
    // Core Dataのコンテキストを管理
    private let persistentContainer: NSPersistentContainer
    private var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    // アプリのデータ状態
    @Published var entries: [DevotionEntry] = []
    @Published var todayEntry: DevotionEntry?
    @Published var selectedDate: Date = Date()
    @Published var entriesForSelectedMonth: [Date] = []
    
    // カレンダー関連
    @Published var currentMonth: Date = Date()
    
    init() {
        // Core Dataのセットアップ
        persistentContainer = NSPersistentContainer(name: "SOAPJournal")
        persistentContainer.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Core Data store failed to load: \(error.localizedDescription)")
            }
        }
        
        // 自動保存の設定
        context.automaticallyMergesChangesFromParent = true
    }
    
    // すべてのエントリをロード
    func loadEntries() {
        let request = DevotionEntry.fetchRequest()
        
        do {
            entries = try context.fetch(request)
            checkForTodayEntry()
            updateEntriesForSelectedMonth()
        } catch {
            print("エントリのロードに失敗しました: \(error)")
        }
    }
    
    // 指定した日付のエントリを検索
    func getEntryFor(date: Date) -> DevotionEntry? {
        let request = DevotionEntry.fetchRequestForDate(date)
        
        do {
            let results = try context.fetch(request)
            return results.first
        } catch {
            print("特定日付のエントリ取得に失敗しました: \(error)")
            return nil
        }
    }
    
    // 新しいエントリを作成/更新
    func saveEntry(scripture: String, observation: String, application: String, prayer: String, date: Date = Date()) {
        if let existingEntry = getEntryFor(date: date) {
            // 既存のエントリを更新
            existingEntry.scripture = scripture
            existingEntry.observation = observation
            existingEntry.application = application
            existingEntry.prayer = prayer
            
            do {
                try context.save()
                loadEntries() // データを再ロード
            } catch {
                print("エントリの更新に失敗しました: \(error)")
            }
        } else {
            // 新しいエントリを作成
            _ = DevotionEntry.createWith(
                scripture: scripture,
                observation: observation,
                application: application,
                prayer: prayer,
                date: date,
                using: context
            )
            
            loadEntries() // データを再ロード
        }
    }
    
    // エントリを削除
    func deleteEntry(_ entry: DevotionEntry) {
        context.delete(entry)
        
        do {
            try context.save()
            loadEntries() // データを再ロード
        } catch {
            print("エントリの削除に失敗しました: \(error)")
        }
    }
    
    // 今日のエントリがあるか確認
    func checkForTodayEntry() {
        todayEntry = getEntryFor(date: Date())
    }
    
    // 選択された月のエントリを更新
    func updateEntriesForSelectedMonth() {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: currentMonth)
        
        guard let year = components.year, let month = components.month else { return }
        
        entriesForSelectedMonth = DevotionEntry.fetchDatesForMonth(
            year: year,
            month: month,
            context: context
        )
    }
    
    // 月を変更
    func changeMonth(by value: Int) {
        if let newDate = Calendar.current.date(byAdding: .month, value: value, to: currentMonth) {
            currentMonth = newDate
            updateEntriesForSelectedMonth()
        }
    }
}
