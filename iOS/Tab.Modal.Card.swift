import SwiftUI
import Archivable

extension Tab.Modal {
    struct Card: View, Tabber {
        @Binding var session: Session
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
                            browse.map(Cloud.shared.bookmark)
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
                            
                        }
                    }
                    if session[id].loading {
                        Control(title: "Stop", image: "xmark") {
                            
                        }
                    } else {
                        Control(title: "Refresh", image: "arrow.clockwise") {
                            
                        }
                    }
                    Spacer()
                }
                .padding([.top, .leading, .trailing])
            }
        }
    }
}
