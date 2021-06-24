import SwiftUI

extension Tab {
    struct Bar: View {
        @Binding var session: Session
        @Binding var modal: Bool
        let id: UUID
        let tabs: () -> Void
        
        var body: some View {
            VStack {
                Spacer()
                ZStack {
                    Blur(style: .systemThinMaterial)
                        .edgesIgnoringSafeArea([.bottom, .leading, .trailing])
                    VStack(spacing: 0) {
                        Rectangle()
                            .fill(Color.primary.opacity(0.2))
                            .frame(height: 1)
                            .allowsHitTesting(false)
                        HStack(spacing: 0) {
                            Control(disabled: !session.tab[state: id].isBrowse || !session.tab[back: id], image: "arrow.left") {
                                session.back.send(id)
                            }
                            Control(disabled: !session.tab[state: id].isBrowse || !session.tab[forward: id], image: "arrow.right") {
                                session.forward.send(id)
                            }
                            Control(image: "magnifyingglass") {
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    session.section = .search(id)
                                }
                                session.search.send()
                            }
                            Control(disabled: !session.tab[state: id].isBrowse, image: "line.horizontal.3") {
                                UIApplication.shared.resign()
                                withAnimation(.easeInOut(duration: 0.25)) {
                                    modal = true
                                }
                            }
                            Control(image: "app", action: tabs)
                        }
                        .frame(height: 34)
                        .padding(.horizontal)
                        .padding(.vertical, 10)
                    }
                }
                .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
}
