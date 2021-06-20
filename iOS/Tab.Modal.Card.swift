import SwiftUI

extension Tab.Modal {
    struct Card: View {
        @Binding var session: Session
        @Binding var find: Bool
        let id: UUID
        let dismiss: () -> Void
        
        var body: some View {
            ZStack {
                RoundedRectangle(cornerRadius: 14)
                    .fill(Color(.systemBackground).opacity(0.5))
                VStack {
                    HStack {
                        Control(title: "Info", image: "info.circle") {
                            dismiss()
                            session.modal = .info(id)
                        }
                        Control(title: "Bookmark", image: "bookmark") {
                            session.tab[state: id].browse
                                .map(cloud.bookmark)
                            dismiss()
                            withAnimation(.easeInOut(duration: 0.4)) {
                                session.toast = .init(title: "Bookmark added", icon: "bookmark")
                            }
                        }
                    }
                    HStack {
                        Control(title: "Share", image: "square.and.arrow.up") {
                            dismiss()
                            session.modal = .options(id)
                        }
                        Control(title: "Find", image: "doc.text.magnifyingglass") {
                            dismiss()
                            find = true
                        }
                    }
                    HStack {
                        Control(title: "Close", image: "xmark") {
                            (session.tab[web: id] as? Web.Coordinator)?.clear()
                            tabber.close(id)
                            session.section = .tabs(id)
                        }
                        if session.tab[loading: id] {
                            Control(title: "Stop", image: "xmark") {
                                
                            }
                        } else {
                            Control(title: "Reload", image: "arrow.clockwise") {
                                dismiss()
                                session.reload.send(id)
                            }
                        }
                    }
                    Spacer()
                }
                .padding(.top, 5)
                .padding([.top, .leading, .trailing])
            }
        }
    }
}
