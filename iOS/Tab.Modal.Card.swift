import SwiftUI

extension Tab.Modal {
    struct Card: View {
        @Binding var session: Session
        let id: UUID
        let dismiss: () -> Void
        
        var body: some View {
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color(.tertiarySystemBackground))
                VStack {
                    if session[id].loading {
                        Control(title: "Stop loading", image: "xmark") {
                            
                        }
                    } else {
                        Control(title: "Refresh", image: "arrow.clockwise") {
                            
                        }
                    }
                    Control(title: "Add bookmark", image: "bookmark") {
                        
                    }
                    Control(title: "Share", image: "gear") {
                        
                    }
                    Control(title: "More", image: "ellipsis") {
                        
                    }
                    Control(title: "Settings", image: "gear") {
                        
                    }
                    Spacer()
                }
                .padding(.top, 8)
            }
        }
    }
}
