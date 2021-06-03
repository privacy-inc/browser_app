import SwiftUI
import Sleuth

extension Tab.New {
    struct History: View {
        @Binding var session: Session
        let id: UUID
        let metrics: Metrics
        
        var body: some View {
            HStack(alignment: .top, spacing: metrics.spacing) {
                ForEach(0 ..< list.count, id: \.self) { column in
                    VStack(spacing: metrics.spacing) {
                        ForEach(0 ..< list[column].count, id: \.self) { index in
                            Cell(browse: list[column][index]) {
                                cloud.revisit(list[column][index].id)
                                tabber.browse(id, list[column][index].id)
                            }
                            .frame(width: metrics.width)
                            .fixedSize()
                        }
                    }
                }
            }
            .padding([.leading, .trailing, .bottom], metrics.spacing * 2)
        }
        
        private var list: [[Browse]] {
            session
                .archive
                .browse
                .prefix(14)
                .reduce(into: (Array(repeating: [], count: metrics.columns), metrics.columns)) {
                    $0.1 = $0.1 < metrics.columns - 1 ? $0.1 + 1 : 0
                    $0.0[$0.1].append($1)
                }
                .0
        }
    }
}
