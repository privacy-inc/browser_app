import SwiftUI

extension Tab.Modal {
    struct Card: View {
        @Binding var session: Session
        @Binding var find: Bool
        let id: UUID
        let dismiss: () -> Void
        
        var body: some View {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color(.tertiarySystemBackground))
                VStack {
                    HStack {
                        Control(title: "Info", image: "info.circle") {
                            dismiss()
                            session.modal = .info(id)
                        }
                        Control(title: "Bookmark", image: "bookmark") {
                            session.tab.state(id).browse
                                .map(cloud.bookmark)
                            dismiss()
                            withAnimation(.easeInOut(duration: 0.4)) {
                                session.toast = .init(title: "Bookmark added", icon: "bookmark")
                            }
                        }
                    }
                    HStack {
                        Control(title: "Options", image: "square.and.arrow.up.on.square") {
                            dismiss()
                            session.modal = .options(id)
                        }
                        Control(title: "Find", image: "doc.text.magnifyingglass") {
                            dismiss()
                            find = true
                        }
                    }
                    if session.tab[loading: id] {
                        Control(title: "Stop", image: "xmark") {
                            
                        }
                    } else {
                        Control(title: "Refresh", image: "arrow.clockwise") {
                            dismiss()
                            session.reload.send(id)
                        }
                    }
                    Spacer()
                }
                .padding([.top, .leading, .trailing])
            }
        }
    }
}
