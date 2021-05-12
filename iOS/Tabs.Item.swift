import SwiftUI
import Sleuth

extension Tabs {
    struct Item: View {
        @Binding var session: Session
        let id: UUID
        
        var body: some View {
            VStack {
                Button {
                    withAnimation(.spring(blendDuration: 0.6)) {
                        session.tab.close(id)
                        session.snapsshots.removeValue(forKey: id)
                    }
                } label: {
                    Image(systemName: "xmark")
                        .foregroundColor(.secondary)
                        .frame(width: 50, height: 50)
                        .contentShape(Rectangle())
                }
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color(.systemBackground))
                    if let image = session.snapsshots[id] {
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 276)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .padding(2)
                    } else {
                        Image(systemName: "magnifyingglass")
                            .font(.largeTitle)
                            .foregroundColor(.accentColor)
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
