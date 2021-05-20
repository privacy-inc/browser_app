import SwiftUI

extension Tabs {
    struct Item: View {
        @Binding var session: Session
        let id: UUID
        let namespace: Namespace.ID
        let size: CGSize
        
        var body: some View {
            VStack {
                Button {
                    withAnimation(.spring(blendDuration: 0.4)) {
                        session.tab.close(id)
                    }
                } label: {
                    Image(systemName: "xmark")
                        .foregroundColor(.primary)
                        .frame(width: 46, height: 45)
                        .contentShape(Rectangle())
                }
                Button {
                    withAnimation(.spring(blendDuration: 0.4)) {
                        session.section = .tab(id)
                    }
                } label: {
                    ZStack {
                        if let image = session.tab[snapshot: id] as? UIImage {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color(.systemBackground))
                                Image(uiImage: image)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: size.width * 0.7, height: size.height - 135)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                                    .padding(2)
                        } else {
                            Image("blank")
                                .frame(width: size.width * 0.7, height: size.height - 135)
                        }
                    }
                }
                Footer(session: $session, id: id)
                    .frame(width: size.width * 0.7, height: 45)
            }
            .matchedGeometryEffect(id: id, in: namespace, properties: .position, isSource: true)
        }
    }
}
