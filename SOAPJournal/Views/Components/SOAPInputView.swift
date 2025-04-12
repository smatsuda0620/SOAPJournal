import SwiftUI

struct SOAPInputView: View {
    @Binding var scripture: String
    @Binding var observation: String
    @Binding var application: String
    @Binding var prayer: String
    
    var body: some View {
        VStack(spacing: 20) {
            // S: 聖句
            inputSection(
                title: NSLocalizedString("scripture", comment: "Scripture label"),
                placeholder: NSLocalizedString("scripture_placeholder", comment: "Scripture placeholder"),
                text: $scripture
            )
            
            // O: 観察・気づき
            inputSection(
                title: NSLocalizedString("observation", comment: "Observation label"),
                placeholder: NSLocalizedString("observation_placeholder", comment: "Observation placeholder"),
                text: $observation
            )
            
            // A: 適用・行動への反映
            inputSection(
                title: NSLocalizedString("application", comment: "Application label"),
                placeholder: NSLocalizedString("application_placeholder", comment: "Application placeholder"),
                text: $application
            )
            
            // P: 祈り
            inputSection(
                title: NSLocalizedString("prayer", comment: "Prayer label"),
                placeholder: NSLocalizedString("prayer_placeholder", comment: "Prayer placeholder"),
                text: $prayer
            )
        }
    }
    
    // 入力セクションのレイアウト
    private func inputSection(title: String, placeholder: String, text: Binding<String>) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.headline)
                .foregroundColor(.indigo)
            
            TextEditor(text: text)
                .frame(minHeight: 100)
                .padding(8)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                )
                .overlay(
                    Group {
                        if text.wrappedValue.isEmpty {
                            Text(placeholder)
                                .foregroundColor(.gray.opacity(0.7))
                                .padding(.horizontal, 12)
                                .padding(.vertical, 12)
                                .allowsHitTesting(false)
                        }
                    }
                )
        }
        .padding(.horizontal)
    }
}
