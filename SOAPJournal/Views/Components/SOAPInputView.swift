import SwiftUI

struct SOAPInputView: View {
    @Binding var scripture: String
    @Binding var observation: String
    @Binding var application: String
    @Binding var prayerCompleted: Bool
    
    @State private var showingPrayerTimer = false
    
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
                        Text("祈りを始める")
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color("PrimaryBrown"))
                            .cornerRadius(8)
                    }
                }
            }
        }
        .padding()
        .sheet(isPresented: $showingPrayerTimer) {
            PrayerTimerView(prayerCompleted: $prayerCompleted)
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

struct SOAPInputView_Previews: PreviewProvider {
    static var previews: some View {
        SOAPInputView(
            scripture: .constant(""),
            observation: .constant(""),
            application: .constant(""),
            prayerCompleted: .constant(false)
        )
    }
}