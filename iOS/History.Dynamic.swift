import SwiftUI
import Sleuth

extension History {
    struct Dynamic: View {
        @Binding var session: Session
        let size: Size
        let horizontal: Bool
        @State private var list = [[Entry]]()
        
        var body: some View {
            ScrollView {
                HStack(alignment: .top) {
                    Spacer()
                    ForEach(0 ..< list.count, id: \.self) { listed in
                        VStack(spacing: Metrics.history.spacing * 2) {
                            ForEach(0 ..< list[listed].count, id: \.self) { index in
                                Cell(entry: list[listed][index], delete: delete) {
                                    UIApplication.shared.resign()
                                    session.section = .browse(list[listed][index].id)
                                }
                            }
                            if !horizontal {
                                Spacer()
                                    .frame(height: Metrics.search.bar)
                            }
                        }
                        .frame(width: size.width)
                        Spacer()
                    }
                }
            }
            .animation(.spring(blendDuration: 0.4))
            .onAppear(perform: refresh)
            .onReceive(Synch.cloud.archive.receive(on: DispatchQueue.main)) { _ in
                refresh()
            }
            .onChange(of: session.search) { _ in
                refresh()
            }
        }
        
        private func refresh() {
            list = ({ search, entries in
                search.isEmpty
                    ? entries
                    : entries
                        .filter {
                            $0.title.localizedCaseInsensitiveContains(search)
                            || $0.url.localizedCaseInsensitiveContains(search)
                        }
            } (session
                .search
                .trimmingCharacters(in: .whitespacesAndNewlines), Synch.cloud.archive.value.entries.reversed()))
            .reduce(into: (Array(repeating: [], count: size.lines), size.lines)) {
                $0.1 = $0.1 < size.lines - 1 ? $0.1 + 1 : 0
                $0.0[$0.1].append($1)
            }.0
        }
        
        private func delete(_ id: Int) {
            UIApplication.shared.resign()
            Synch.cloud.remove(id)
        }
    }
}
