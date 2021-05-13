import SwiftUI

extension Tabs {
    struct Item: View {
        @Binding var session: Session
        let id: UUID
        
        var body: some View {
            VStack {
                Header(session: $session, id: id)
                ZStack {
                    if let image = session.snapsshots[id] {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color(.systemBackground))
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 276)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .padding(2)
                    } else {
                        Image("blank")
                    }
                }
                .frame(maxHeight: .greatestFiniteMagnitude)
                .onTapGesture {
                    withAnimation(.spring(blendDuration: 0.6)) {
                        session.section = .tab(id)
                    }
                }
            }
            .frame(width: 280)
        }
    }
}
