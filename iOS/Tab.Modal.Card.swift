import SwiftUI

extension Tab.Modal {
    struct Card: View {
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
                            
                        }
                        Control(title: "Bookmark", image: "bookmark") {
                            
                        }
                    }
                    HStack {
                        Control(title: "Options", image: "square.and.arrow.up.on.square") {
                            
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
