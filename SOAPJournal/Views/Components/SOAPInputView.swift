import SwiftUI

struct SOAPInputView: View {
    @Binding var scripture: String
    @Binding var observation: String
    @Binding var application: String
    @Binding var prayer: String
    
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
            
            sectionView(
                title: NSLocalizedString("prayer", comment: "Prayer section title"),
                text: $prayer,
                placeholder: NSLocalizedString("prayer_placeholder", comment: "Prayer input placeholder")
            )
        }
        .padding()
    }
    
    private func sectionView(title: String, text: Binding<String>, placeholder: String) -> some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.headline)
                .padding(.bottom, 4)
            
            TextEditor(text: text)
                .frame(minHeight: 80)
                .padding(8)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                )
                .overlay(
                    Group {
                        if text.wrappedValue.isEmpty {
                            Text(placeholder)
                                .foregroundColor(Color.gray.opacity(0.7))
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
            prayer: .constant("")
        )
    }
}