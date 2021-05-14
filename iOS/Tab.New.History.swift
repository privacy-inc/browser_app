import SwiftUI
import Archivable
import Sleuth

extension Tab.New {
    struct History: View {
        @Binding var session: Session
        let id: UUID
        let metrics: Metrics
        @State private var list = [[Sleuth.History]]()
        
        var body: some View {
            HStack(alignment: .top, spacing: metrics.spacing) {
                ForEach(0 ..< list.count, id: \.self) { column in
                    VStack(spacing: metrics.spacing) {
                        ForEach(0 ..< list[column].count, id: \.self) { index in
                            Text(list[column][index].page.title)
                                .frame(width: metrics.width)
                        }
                    }
                }
            }
            .padding(.horizontal, metrics.spacing)
            .onAppear(perform: arrange)
            .onReceive(Cloud.shared.archive) { _ in
                arrange()
            }
        }
        
        private func arrange() {
            list = session
                .archive
                .history
                .prefix(6)
                .reduce(into: (Array(repeating: [], count: metrics.columns), metrics.columns)) {
                    $0.1 = $0.1 < metrics.columns - 1 ? $0.1 + 1 : 0
                    $0.0[$0.1].append($1)
                }
                .0
        }
    }
}
