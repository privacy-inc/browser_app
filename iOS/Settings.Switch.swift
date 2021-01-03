import SwiftUI

extension Settings {
    struct Switch: View {
        let text: LocalizedStringKey
        @Binding var value: Bool
        
        var body: some View {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .foregroundColor(Color(.secondarySystemBackground).opacity(0.3))
                Toggle(text, isOn: $value)
                    .toggleStyle(SwitchToggleStyle(tint: .accentColor))
                    .font(.footnote)
                    .padding(.horizontal)
            }
            .frame(height: 50)
            .padding(.horizontal)
        }
    }
}
