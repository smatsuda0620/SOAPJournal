import Foundation
import CoreData

// このクラスは、CoreDataエンティティとして使用します。
public class DevotionEntry: NSManagedObject {
    @NSManaged public var id: UUID
    @NSManaged public var date: Date
    @NSManaged public var scripture: String
    @NSManaged public var observation: String
    @NSManaged public var application: String
    @NSManaged public var prayer: String
    
    // 新しいエントリを作成する便利なメソッド
    static func create(in context: NSManagedObjectContext,
                       id: UUID = UUID(),
                       date: Date = Date(),
                       scripture: String,
                       observation: String,
                       application: String,
                       prayer: String) -> DevotionEntry {
        
        let entry = DevotionEntry(context: context)
        entry.id = id
        entry.date = date
        entry.scripture = scripture
        entry.observation = observation
        entry.application = application
        entry.prayer = prayer
        
        return entry
    }
}

// 簡単なFetch Requestsを作成するための拡張
extension DevotionEntry {
    static func fetchRequest() -> NSFetchRequest<DevotionEntry> {
        return NSFetchRequest<DevotionEntry>(entityName: "DevotionEntry")
    }
    
    // 特定の日のエントリを取得するためのリクエスト
    static func fetchRequest(for date: Date) -> NSFetchRequest<DevotionEntry> {
        let request: NSFetchRequest<DevotionEntry> = fetchRequest()
        let calendar = Calendar.current
        
        let dayStart = calendar.startOfDay(for: date)
        var components = DateComponents()
        components.day = 1
        components.second = -1
        let dayEnd = calendar.date(byAdding: components, to: dayStart)!
        
        request.predicate = NSPredicate(format: "date >= %@ AND date <= %@", dayStart as NSDate, dayEnd as NSDate)
        return request
    }
    
    // すべてのエントリを最新順に取得するリクエスト
    static func fetchAllSortedByDateRequest() -> NSFetchRequest<DevotionEntry> {
        let request: NSFetchRequest<DevotionEntry> = fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \DevotionEntry.date, ascending: false)]
        return request
    }
}