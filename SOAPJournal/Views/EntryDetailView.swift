import SwiftUI

struct EntryDetailView: View {
    @EnvironmentObject var devotionManager: DevotionManager
    let entry: DevotionEntry
    
    @State private var isEditing = false
    @State private var scripture: String = ""
    @State private var observation: String = ""
    @State private var application: String = ""
    @State private var prayer: String = ""
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // 日付表示
                Text(entry.date, style: .date)
                    .font(.headline)
                    .padding(.horizontal)
                
                if isEditing {
                    // 編集モード
                    SOAPInputView(
                        scripture: $scripture,
                        observation: $observation,
                        application: $application,
                        prayer: $prayer
                    )
                    
                    // 保存ボタン
                    Button(action: saveChanges) {
                        Text(NSLocalizedString("save_changes", comment: "Save changes button"))
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.indigo)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 30)
                } else {
                    // 表示モード
                    Group {
                        VStack(alignment: .leading, spacing: 10) {
                            Text(NSLocalizedString("scripture", comment: "Scripture label"))
                                .font(.headline)
                                .foregroundColor(.indigo)
                            
                            Text(entry.scripture)
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color(.systemGray6))
                                .cornerRadius(8)
                        }
                        .padding(.horizontal)
                        
                        VStack(alignment: .leading, spacing: 10) {
                            Text(NSLocalizedString("observation", comment: "Observation label"))
                                .font(.headline)
                                .foregroundColor(.indigo)
                            
                            Text(entry.observation)
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color(.systemGray6))
                                .cornerRadius(8)
                        }
                        .padding(.horizontal)
                        
                        VStack(alignment: .leading, spacing: 10) {
                            Text(NSLocalizedString("application", comment: "Application label"))
                                .font(.headline)
                                .foregroundColor(.indigo)
                            
                            Text(entry.application)
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color(.systemGray6))
                                .cornerRadius(8)
                        }
                        .padding(.horizontal)
                        
                        VStack(alignment: .leading, spacing: 10) {
                            Text(NSLocalizedString("prayer", comment: "Prayer label"))
                                .font(.headline)
                                .foregroundColor(.indigo)
                            
                            Text(entry.prayer)
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color(.systemGray6))
                                .cornerRadius(8)
                        }
                        .padding(.horizontal)
                    }
                }
            }
            .padding(.vertical)
        }
        .navigationTitle(NSLocalizedString("devotion_entry", comment: "Devotion entry"))
        .toolbar {
            Button(isEditing ? NSLocalizedString("cancel", comment: "Cancel button") : NSLocalizedString("edit", comment: "Edit button")) {
                if isEditing {
                    // キャンセル時は元の値に戻す
                    isEditing = false
                } else {
                    // 編集開始時に現在の値をセット
                    scripture = entry.scripture
                    observation = entry.observation
                    application = entry.application
                    prayer = entry.prayer
                    isEditing = true
                }
            }
        }
    }
    
    // 変更を保存
    private func saveChanges() {
        devotionManager.saveEntry(
            scripture: scripture,
            observation: observation,
            application: application,
            prayer: prayer,
            date: entry.date
        )
        
        isEditing = false
    }
}
