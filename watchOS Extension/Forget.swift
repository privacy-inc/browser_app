import SwiftUI

struct Forget: View {
    @State private var done = false
    
    var body: some View {
        List {
            if done {
                Section(header:
                    Image(systemName: "checkmark.circle.fill")
                            .font(.title)
                            .foregroundColor(.blue)
                            .frame(maxWidth: .greatestFiniteMagnitude)
                            .padding(.vertical)) {
                }
            }
            Section {
                Cell(title: "Forget history") {
                    cloud.forgetBrowse()
                    confirm()
                }
                Cell(title: "Forget activity") {
                    cloud.forgetActivity()
                    confirm()
                }
                Cell(title: "Forget trackers") {
                    cloud.forgetBlocked()
                    confirm()
                }
            }
            .foregroundColor(.primary)
            Section {
                Cell(title: "Forget everything") {
                    cloud.forget()
                    confirm()
                }
                .foregroundColor(.pink)
            }
        }
    }
    
    private func confirm() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            withAnimation(.easeInOut(duration: 0.3)) {
                done = true
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 6) {
            withAnimation(.easeInOut(duration: 0.3)) {
                done = false
            }
        }
    }
}
