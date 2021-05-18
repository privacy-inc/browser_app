import SwiftUI

extension Tab {
    struct Bar: View, Tabber {
        @Binding var session: Session
        @Binding var modal: Bool
        let id: UUID
        let snapshot: () -> Void
        
        var body: some View {
            ZStack {
                Color(.quaternarySystemFill)
                    .edgesIgnoringSafeArea([.bottom, .leading, .trailing])
                HStack(spacing: 0) {
                    Control(disabled: !session[id].back, image: "arrow.left") {
                        session.back.send(id)
                    }
                    Control(disabled: !session[id].forward, image: "arrow.right") {
                        session.forward.send(id)
                    }
                    Search(session: $session, id: id)
                        .padding(.horizontal, 10)
                    Control(image: "app") {
                        withAnimation(.spring(blendDuration: 0.4)) {
                            session.section = .tabs(id)
                            snapshot()
                        }
                    }
                    Control(disabled: browse == nil, image: "line.horizontal.3") {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            modal = true
                        }
                    }
                }
                .padding(.horizontal)
                .frame(height: 34)
                .padding(.vertical, 10)
            }
            .fixedSize(horizontal: false, vertical: true)
        }
    }
}
