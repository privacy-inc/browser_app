import SwiftUI

struct Tab: View {
    @Binding var session: Session
    let id: UUID
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(spacing: 0) {
                    Text("Hello world!")
                }
            }
            .frame(maxHeight: .greatestFiniteMagnitude)
            Bar(session: $session, snapshot: snapshot)
        }
    }
    
    private func snapshot() {
        let controller = UIHostingController(rootView: self)
        controller.view?.bounds = .init(origin: .zero, size: controller.view.intrinsicContentSize)
//        controller.view?.backgroundColor = .clear
        session.snapsshots[id] = UIGraphicsImageRenderer(size: controller.view.bounds.size)
            .image { _ in
                controller.view?.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
            }
    }
}
