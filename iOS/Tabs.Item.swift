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
                    (session.tab[web: id] as? Web.Coordinator)?.clear()
                    withAnimation(.spring(blendDuration: 0.4)) {
                        tabber.close(id)
                    }
                } label: {
                    HStack {
                        Rectangle()
                            .fill(Color(.systemFill))
                            .frame(height: 1)
                            .allowsHitTesting(false)
                        Image(systemName: "xmark")
                            .foregroundColor(.primary)
                            .frame(height: 45)
                            .contentShape(Rectangle())
                        Rectangle()
                            .fill(Color(.systemFill))
                            .frame(height: 1)
                    }
                    .padding(.horizontal, 30)
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
                                    .frame(width: size.width * 0.7, height: size.height - 140)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                    .padding(2)
                        } else {
                            Image("blank")
                                .frame(width: size.width * 0.7, height: size.height - 145)
                        }
                    }
                    .fixedSize()
                }
                Footer(session: $session, id: id)
                Spacer()
            }
            .matchedGeometryEffect(id: id, in: namespace, properties: .position, isSource: false)
        }
    }
}
