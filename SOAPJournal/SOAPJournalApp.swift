import SwiftUI
import CoreData
import CloudKit

@main
struct SOAPJournalApp: App {
    // CoreDataのPersistenceController
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            SplashView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

// CoreDataのPersistenceControllerの定義
class PersistenceController {
    // シングルトンインスタンス
    static let shared = PersistenceController()
    
    // プレビュー用のインスタンス（サンプルデータ含む）
    static var preview: PersistenceController = {
        let controller = PersistenceController(inMemory: true)
        let viewContext = controller.container.viewContext
        
        // サンプルデータを作成
        let today = Date()
        let calendar = Calendar.current
        
        // 今日のエントリー
        _ = DevotionEntry.create(
            in: viewContext,
            date: today,
            scripture: "ヨハネ3:16 神は、実に、そのひとり子をお与えになったほどに世を愛された。それは御子を信じる者が、一人として滅びることなく、永遠のいのちを持つためである。",
            observation: "神様は世を愛するために最高の犠牲を払った。神の愛は無条件で、誰にでも与えられる。",
            application: "神様の無条件の愛を受け入れ、周りの人たちにもその愛を示していきたい。",
            prayer: "神様、あなたの深い愛に感謝します。私もあなたの愛を実践できるよう導いてください。"
        )
        
        // 昨日のエントリー
        _ = DevotionEntry.create(
            in: viewContext,
            date: calendar.date(byAdding: .day, value: -1, to: today)!,
            scripture: "詩篇23:1 主は私の羊飼い。私は、乏しいことがありません。",
            observation: "神様は羊飼いのように私たちを導き、必要なものをすべて与えてくださる。",
            application: "不安や心配があっても、神様が導いてくださると信頼する。",
            prayer: "主よ、あなたの導きに感謝します。信仰の目で前を見て歩めるよう助けてください。"
        )
        
        // 先週のエントリー
        _ = DevotionEntry.create(
            in: viewContext,
            date: calendar.date(byAdding: .day, value: -7, to: today)!,
            scripture: "マタイ5:14-16 あなたがたは、世界の光です...",
            observation: "クリスチャンは世の光として生きる責任がある。",
            application: "日常生活の中で、キリストの光を輝かせる方法を考えよう。",
            prayer: "神様、あなたの光を世に示せるよう助けてください。"
        )
        
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("CoreData保存エラー: \(nsError)")
        }
        
        return controller
    }()
    
    // CoreDataスタックの初期化
    let container: NSPersistentContainer
    
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "SOAPJournal")
        
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        
        container.loadPersistentStores { description, error in
            if let error = error as NSError? {
                // エラーログを出力しますが、アプリはクラッシュさせません
                print("CoreDataスタックのロードエラー: \(error), \(error.userInfo)")
            }
        }
        
        // メモリ管理のための設定
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }
}