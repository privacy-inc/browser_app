import SwiftUI

extension Tab {
    struct Bar: View {
        @Binding var session: Session
        let id: UUID
        let snapshot: () -> Void
        
        var body: some View {
            ZStack {
                Color(.quaternarySystemFill)
                    .edgesIgnoringSafeArea([.bottom, .leading, .trailing])
                HStack(spacing: 0) {
                    Control(disabled: true, image: "arrow.left") {
                        
                    }
                    Control(disabled: true, image: "arrow.right") {
                        
                    }
                    Search(session: $session, id: id)
                        .padding(.horizontal, 10)
                    Control(image: "app") {
                        withAnimation(.spring(blendDuration: 0.6)) {
                            session.section = .tabs(id)
                            snapshot()
                        }
                    }
                    Control(image: "line.horizontal.3") {
                        
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
