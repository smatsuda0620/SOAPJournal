import Foundation
import CoreData

class DevotionEntry: NSManagedObject, Identifiable {
    @NSManaged public var id: UUID
    @NSManaged public var date: Date
    @NSManaged public var scripture: String
    @NSManaged public var observation: String
    @NSManaged public var application: String
    @NSManaged public var prayer: String
    
    // 新しいエントリを作成する
    static func createWith(
        scripture: String,
        observation: String,
        application: String,
        prayer: String,
        date: Date = Date(),
        using context: NSManagedObjectContext
    ) -> DevotionEntry {
        let entry = DevotionEntry(context: context)
        entry.id = UUID()
        entry.date = date
        entry.scripture = scripture
        entry.observation = observation
        entry.application = application
        entry.prayer = prayer
        
        do {
            try context.save()
            return entry
        } catch {
            // エラーハンドリング
            print("エントリーの保存に失敗しました: \(error)")
            context.rollback()
            fatalError("エントリーの保存に失敗: \(error)")
        }
    }
}

extension DevotionEntry {
    // エントリを日付で取得する
    static func fetchRequestForDate(_ date: Date) -> NSFetchRequest<DevotionEntry> {
        let request = NSFetchRequest<DevotionEntry>(entityName: "DevotionEntry")
        let calendar = Calendar.current
        
        let startDate = calendar.startOfDay(for: date)
        let endDate = calendar.date(byAdding: .day, value: 1, to: startDate)!
        
        request.predicate = NSPredicate(format: "date >= %@ AND date < %@", startDate as NSDate, endDate as NSDate)
        request.sortDescriptors = [NSSortDescriptor(keyPath: \DevotionEntry.date, ascending: false)]
        
        return request
    }
    
    // すべてのエントリを取得する
    static func fetchRequest() -> NSFetchRequest<DevotionEntry> {
        let request = NSFetchRequest<DevotionEntry>(entityName: "DevotionEntry")
        request.sortDescriptors = [NSSortDescriptor(keyPath: \DevotionEntry.date, ascending: false)]
        return request
    }
    
    // 指定した月のエントリ日を取得する（カレンダー表示用）
    static func fetchDatesForMonth(year: Int, month: Int, context: NSManagedObjectContext) -> [Date] {
        let calendar = Calendar.current
        
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = 1
        
        guard let startDate = calendar.date(from: components) else { return [] }
        guard let endDate = calendar.date(byAdding: .month, value: 1, to: startDate) else { return [] }
        
        let request = NSFetchRequest<DevotionEntry>(entityName: "DevotionEntry")
        request.predicate = NSPredicate(format: "date >= %@ AND date < %@", startDate as NSDate, endDate as NSDate)
        
        do {
            let entries = try context.fetch(request)
            return entries.map { calendar.startOfDay(for: $0.date) }
        } catch {
            print("月の記録取得に失敗しました: \(error)")
            return []
        }
    }
}
