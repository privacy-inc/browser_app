import SwiftUI

extension Tab {
    struct Modal: View {
        @Binding var session: Session
        @Binding var show: Bool
        let id: UUID
        @State private var offset = CGFloat()
        
        var body: some View {
            ZStack {
                if show {
                    Color.black.opacity(0.7)
                        .edgesIgnoringSafeArea(.all)
                        .onTapGesture(perform: dismiss)
                    VStack(spacing: 0) {
                        Spacer()
                        HStack {
                            Capsule()
                                .fill(Color(.tertiarySystemBackground))
                                .frame(width: 60, height: 3)
                                .padding(.bottom, 12)
                                .padding(.top, 40)
                        }
                        .frame(maxWidth: .greatestFiniteMagnitude)
                        .contentShape(Rectangle())
                        .onTapGesture(perform: dismiss)
                        Card(session: $session, id: id, dismiss: dismiss)
                            .frame(height: 380)
                    }
                    .offset(y: 380 + offset)
                    .edgesIgnoringSafeArea(.bottom)
                    .highPriorityGesture(
                        DragGesture()
                            .onChanged { gesture in
                                withAnimation(.spring(blendDuration: 0.25)) {
                                    offset = max(-230 + gesture.translation.height, -380)
                                }
                            }
                            .onEnded {
                                if $0.translation.height > 70 {
                                    dismiss()
                                } else {
                                    withAnimation(.easeInOut(duration: 0.3)) {
                                        offset = -230
                                    }
                                }
                            }
                    )
                }
            }
            .onChange(of: show) {
                if $0 {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                        withAnimation(.spring(blendDuration: 0.2)) {
                            offset = -230
                        }
                    }
                }
            }
        }
        
        private func dismiss() {
            withAnimation(.spring(blendDuration: 0.2)) {
                offset = 0
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.easeInOut(duration: 0.2)) {
                    show = false
                }
            }
        }
    }
}
