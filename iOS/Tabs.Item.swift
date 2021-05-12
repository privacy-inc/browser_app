import SwiftUI
import Sleuth

extension Tabs {
    struct Item: View {
        @Binding var session: Session
        let id: UUID
        
        var body: some View {
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color(.systemBackground))
                session.snapsshots[id].map {
                    Image(uiImage: $0)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 280)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .padding(2)
                }
            }
            .frame(maxHeight: .greatestFiniteMagnitude)
            .onTapGesture {
                withAnimation(.spring(blendDuration: 0.6)) {
                    session.section = .tab(id)
                }
            }
        }
    }
}
