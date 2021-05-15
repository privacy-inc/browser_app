import SwiftUI

extension Tab {
    struct Modal: View {
        @Binding var session: Session
        @Binding var show: Bool
        let id: UUID
        @State private var offset = CGFloat(600)
        
        var body: some View {
            ZStack {
                if show {
                    Color.black.opacity(0.6)
                        .edgesIgnoringSafeArea(.all)
                        .onTapGesture(perform: dismiss)
                    VStack(spacing: 0) {
                        Spacer()
                        HStack {
                            Capsule()
                                .fill(Color(.systemBackground))
                                .frame(width: 60, height: 3)
                                .padding(.bottom, 12)
                                .padding(.top, 40)
                        }
                        .frame(maxWidth: .greatestFiniteMagnitude)
                        .contentShape(Rectangle())
                        .onTapGesture(perform: dismiss)
                        Card(session: $session, id: id, dismiss: dismiss)
                    }
                    .offset(y: 300 + offset)
                    .edgesIgnoringSafeArea(.bottom)
                    .highPriorityGesture(
                        DragGesture()
                            .onChanged { gesture in
                                withAnimation(.spring(blendDuration: 0.25)) {
                                    offset = max(gesture.translation.height, -300)
                                }
                            }
                            .onEnded {
                                if $0.translation.height > 120 {
                                    dismiss()
                                } else {
                                    withAnimation(.easeInOut(duration: 0.3)) {
                                        offset = 0
                                    }
                                }
                            }
                    )
                }
            }
            .onChange(of: show) {
                if $0 {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                        withAnimation(.spring(blendDuration: 0.3)) {
                            offset = 0
                        }
                    }
                }
            }
        }
        
        private func dismiss() {
            withAnimation(.spring(blendDuration: 0.3)) {
                offset = 600
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                withAnimation(.easeInOut(duration: 0.25)) {
                    show = false
                }
            }
        }
    }
}
