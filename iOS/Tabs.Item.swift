import SwiftUI

extension Tabs {
    struct Item: View {
        @Binding var session: Session
        let id: UUID
        let namespace: Namespace.ID
        let size: CGSize
        
        var body: some View {
            VStack {
                Header(session: $session, id: id)
                    .frame(width: size.width * 0.7, height: 65)
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
                                    .frame(width: size.width * 0.7, height: size.height - 102)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                                    .padding(2)
                        } else {
                            Image("blank")
                                .frame(width: size.width * 0.7, height: size.height - 102)
                        }
                    }
                }
            }
            .matchedGeometryEffect(id: id, in: namespace, properties: .position, isSource: true)
        }
    }
}
