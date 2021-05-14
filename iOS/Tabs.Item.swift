import SwiftUI

extension Tabs {
    struct Item: View {
        @Binding var session: Session
        let id: UUID
        let size: CGSize
        
        var body: some View {
            VStack {
                Header(session: $session, id: id)
                ZStack {
                    if let image = session[id].image {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color(.systemBackground))
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: size.width * 0.7, height: size.height - 102)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .padding(2)
                    } else {
                        Image("blank")
                            .frame(width: size.width * 0.7, height: size.height - 102)
                    }
                }
                .onTapGesture {
                    withAnimation(.spring(blendDuration: 0.6)) {
                        session.section = .tab(id)
                    }
                }
            }
        }
    }
}
