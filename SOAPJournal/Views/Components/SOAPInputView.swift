import SwiftUI

struct SOAPInputView: View {
    @Binding var scripture: String
    @Binding var observation: String
    @Binding var application: String
    @Binding var prayerCompleted: Bool
    
    @State private var showingPrayerTimer = false
    @State private var showingSavedAlert = false
    
    // DevotionManagerを環境変数から取得
    @EnvironmentObject var devotionManager: DevotionManager
    
    // SOAPの入力が有効かどうかを判定する計算プロパティ
    private var isSOAPInputValid: Bool {
        !scripture.isEmpty && !observation.isEmpty && !application.isEmpty
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionView(
                title: NSLocalizedString("scripture", comment: "Scripture section title"),
                text: $scripture,
                placeholder: NSLocalizedString("scripture_placeholder", comment: "Scripture input placeholder")
            )
            
            sectionView(
                title: NSLocalizedString("observation", comment: "Observation section title"),
                text: $observation,
                placeholder: NSLocalizedString("observation_placeholder", comment: "Observation input placeholder")
            )
            
            sectionView(
                title: NSLocalizedString("application", comment: "Application section title"),
                text: $application,
                placeholder: NSLocalizedString("application_placeholder", comment: "Application input placeholder")
            )
            
            // 祈りセクション（タイマーボタンを表示）
            VStack(alignment: .leading, spacing: 8) {
                Text(NSLocalizedString("prayer", comment: "Prayer section title"))
                    .font(.headline)
                    .foregroundColor(Color("PrimaryBrown"))
                
                if prayerCompleted {
                    HStack {
                        Text("祈りを完了しました")
                            .foregroundColor(Color("PrimaryBrown"))
                            .padding()
                            .background(Color("BackgroundCream"))
                            .cornerRadius(8)
                        
                        Spacer()
                        
                        // リセットボタン
                        Button(action: {
                            prayerCompleted = false
                        }) {
                            Image(systemName: "arrow.counterclockwise")
                                .foregroundColor(Color("PrimaryBrown"))
                        }
                    }
                } else {
                    Button(action: {
                        showingPrayerTimer = true
                    }) {
                        Text(NSLocalizedString("start_prayer", comment: "Start prayer button"))
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(isSOAPInputValid ? Color("PrimaryBrown") : Color.gray)
                            .cornerRadius(8)
                    }
                    .disabled(!isSOAPInputValid)
                }
            }
        }
        .padding()
        .sheet(isPresented: $showingPrayerTimer) {
            PrayerTimerView(prayerCompleted: $prayerCompleted)
        }
        .onChange(of: prayerCompleted) { completed in
            if completed {
                // 祈りが完了したら自動保存
                saveEntry()
            }
        }
        .alert(isPresented: $showingSavedAlert) {
            Alert(
                title: Text(NSLocalizedString("entry_saved", comment: "Entry saved alert title")),
                message: Text(NSLocalizedString("devotion_saved_message", comment: "Your devotion has been saved")),
                dismissButton: .default(Text(NSLocalizedString("ok", comment: "OK button")))
            )
        }
    }
    
    private func sectionView(title: String, text: Binding<String>, placeholder: String) -> some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.headline)
                .foregroundColor(Color("PrimaryBrown"))
                .padding(.bottom, 4)
            
            TextEditor(text: text)
                .frame(minHeight: 80)
                .padding(8)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color("PrimaryBrown").opacity(0.3), lineWidth: 1)
                        .background(Color("BackgroundCream").cornerRadius(8))
                )
                .overlay(
                    Group {
                        if text.wrappedValue.isEmpty {
                            Text(placeholder)
                                .foregroundColor(Color("PrimaryBrown").opacity(0.5))
                                .padding(.horizontal, 12)
                                .padding(.vertical, 12)
                                .allowsHitTesting(false)
                        }
                    }, alignment: .topLeading
                )
        }
    }
}

extension SOAPInputView {
    // エントリーを保存する関数
    private func saveEntry() {
        devotionManager.createEntry(
            scripture: scripture,
            observation: observation,
            application: application,
            prayerCompleted: prayerCompleted
        )
        
        showingSavedAlert = true
    }
}

struct SOAPInputView_Previews: PreviewProvider {
    static var previews: some View {
        SOAPInputView(
            scripture: .constant(""),
            observation: .constant(""),
            application: .constant(""),
            prayerCompleted: .constant(false)
        )
        .environmentObject(DevotionManager(context: PersistenceController.preview.container.viewContext))
    }
}