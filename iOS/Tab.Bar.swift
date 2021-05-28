import SwiftUI

extension Tab {
    struct Bar: View {
        @Binding var session: Session
        @Binding var modal: Bool
        let id: UUID
        let tabs: () -> Void
        
        var body: some View {
            ZStack {
                Color(.quaternarySystemFill)
                    .edgesIgnoringSafeArea([.bottom, .leading, .trailing])
                HStack(spacing: 0) {
                    Control(disabled: error || !session.tabs[back: id], image: "arrow.left") {
                        session.back.send(id)
                    }
                    Control(disabled: error || !session.tabs[forward: id], image: "arrow.right") {
                        session.forward.send(id)
                    }
                    Search(session: $session, id: id)
                        .padding(.horizontal, 10)
                    Control(disabled: error || session.tabs.state(id).browse == nil, image: "line.horizontal.3") {
                        UIApplication.shared.resign()
                        withAnimation(.easeInOut(duration: 0.3)) {
                            modal = true
                        }
                    }
                    Control(image: "app", action: tabs)
                }
                .frame(height: 34)
                .padding(.horizontal)
                .padding(.vertical, 10)
            }
            .fixedSize(horizontal: false, vertical: true)
        }
        
        private var error: Bool {
            switch session.tabs.state(id) {
            case .error:
                return true
            default:
                return false
            }
        }
    }
}
