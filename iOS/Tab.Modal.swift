import SwiftUI

extension Tab {
    struct Modal: View {
        @Binding var session: Session
        @Binding var show: Bool
        @Binding var find: Bool
        let id: UUID
        @State private var offset = CGFloat()
        
        var body: some View {
            ZStack {
                if show {
                    Blur(style: .systemUltraThinMaterialDark)
                        .edgesIgnoringSafeArea(.all)
                        .onTapGesture(perform: dismiss)
                    VStack(spacing: 0) {
                        Spacer()
                        HStack {
                            Capsule()
                                .fill(Color(.systemBackground).opacity(0.3))
                                .frame(width: 60, height: 3)
                                .padding(.bottom, 12)
                                .padding(.top, 40)
                        }
                        .frame(maxWidth: .greatestFiniteMagnitude)
                        .contentShape(Rectangle())
                        .onTapGesture(perform: dismiss)
                        Card(session: $session, find: $find, id: id, dismiss: dismiss)
                            .frame(height: 400)
                    }
                    .offset(y: 400 + offset)
                    .edgesIgnoringSafeArea(.bottom)
                    .highPriorityGesture(
                        DragGesture()
                            .onChanged { gesture in
                                withAnimation(.spring(blendDuration: 0.25)) {
                                    offset = max(-280 + gesture.translation.height, -400)
                                }
                            }
                            .onEnded {
                                if $0.translation.height > 70 {
                                    dismiss()
                                } else {
                                    withAnimation(.easeInOut(duration: 0.3)) {
                                        offset = -280
                                    }
                                }
                            }
                    )
                }
            }
            .allowsHitTesting(show)
            .accessibilityAddTraits(.isModal)
            .onChange(of: show) {
                if $0 {
                    find = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                        withAnimation(.spring(blendDuration: 0.1)) {
                            offset = -280
                        }
                    }
                }
            }
        }
        
        private func dismiss() {
            UIApplication.shared.resign()
            withAnimation(.spring(blendDuration: 0.15)) {
                offset = 0
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                withAnimation(.easeInOut(duration: 0.1)) {
                    show = false
                }
            }
        }
    }
}
