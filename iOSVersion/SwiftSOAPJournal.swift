import Foundation

// デボーション記録のデータモデル
struct DevotionData: Codable, Identifiable {
    var id: UUID
    var date: Date
    var scripture: String
    var observation: String
    var application: String
    var prayer: String
    
    init(id: UUID = UUID(), date: Date = Date(), scripture: String = "", observation: String = "", application: String = "", prayer: String = "") {
        self.id = id
        self.date = date
        self.scripture = scripture
        self.observation = observation
        self.application = application
        self.prayer = prayer
    }
}

// データ管理クラス
class SOAPJournalManager {
    private var entries: [DevotionData] = []
    private let fileURL: URL
    
    init() {
        // データ保存先のファイルURL
        let documentsDirectory = FileManager.default.currentDirectoryPath
        self.fileURL = URL(fileURLWithPath: documentsDirectory).appendingPathComponent("devotions.json")
        
        // 保存されたデータをロード
        loadEntries()
    }
    
    // エントリーを読み込む
    func loadEntries() {
        if FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                let data = try Data(contentsOf: fileURL)
                entries = try JSONDecoder().decode([DevotionData].self, from: data)
                print("エントリーを読み込みました: \(entries.count)件")
            } catch {
                print("エントリーの読み込みに失敗しました: \(error)")
                entries = []
            }
        }
    }
    
    // エントリーを保存する
    func saveEntries() {
        do {
            let data = try JSONEncoder().encode(entries)
            try data.write(to: fileURL)
            print("エントリーを保存しました: \(entries.count)件")
        } catch {
            print("エントリーの保存に失敗しました: \(error)")
        }
    }
    
    // 新しいエントリーを追加
    func addEntry(_ entry: DevotionData) {
        entries.append(entry)
        saveEntries()
    }
    
    // 特定の日付のエントリーを取得
    func getEntryForDate(_ date: Date) -> DevotionData? {
        let calendar = Calendar.current
        return entries.first { entry in
            calendar.isDate(entry.date, inSameDayAs: date)
        }
    }
    
    // 全てのエントリーを取得
    func getAllEntries() -> [DevotionData] {
        return entries.sorted { $0.date > $1.date }
    }
    
    // エントリーを削除
    func deleteEntry(withId id: UUID) {
        entries.removeAll { $0.id == id }
        saveEntries()
    }
}

/*
 * このファイルはSOAPジャーナルアプリのiOS版の基本構造を示しています。
 * 実際のアプリケーションでは、SwiftUIと組み合わせて使用します。
 *
 * SwiftUI版の主な機能:
 * - CoreDataを使用したデータ永続化
 * - タブベースのナビゲーション（今日のデボーション、カレンダー、履歴）
 * - ローカライゼーション（日本語および英語サポート）
 * - カレンダーでのデボーション習慣の可視化
 * - SOAPメソッド（聖句、観察、適用、祈り）を使用した構造化された入力
 */

// iOS版アプリの概要を表示する関数（実装は別ファイルに）
func showIOSAppDescription() {
    print("================================")
    print("SOAPジャーナル - iOS版の特徴")
    print("================================")
    print("1. タブベースのナビゲーション")
    print("   - 今日: 今日のデボーションを記録")
    print("   - カレンダー: 習慣の可視化")
    print("   - 履歴: 過去の記録を閲覧")
    print("")
    print("2. 完全な日本語サポート")
    print("   - UIのローカライゼーション")
    print("   - 日本語フォントと言語処理の最適化")
    print("")
    print("3. CoreDataによるデータ管理")
    print("   - 安全なデータ保存")
    print("   - 効率的なクエリと検索機能")
    print("")
    print("4. モダンなSwiftUIデザイン")
    print("   - クリーンで使いやすいUI")
    print("   - ダイナミックタイプとアクセシビリティ対応")
    print("================================")
}