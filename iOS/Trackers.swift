import SwiftUI
import Sleuth

struct Trackers: View {
    @Binding var session: Session
    @State private var trackers = [(name: String, count: [Date])]()
    @State private var sort = Sleuth.Trackers.attempts
    
    var body: some View {
        Popup(title: "Trackers", leading: {
            Image(systemName: "shield.lefthalf.fill")
                .font(.title2)
                .foregroundColor(.init(.tertiaryLabel))
        }) {
            List {
                Section(header:
                            VStack {
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text(NSNumber(value: trackers.count), formatter: NumberFormatter.decimal)
                                            .font(.largeTitle.monospacedDigit())
                                            .foregroundColor(.primary)
                                        Text("Trackers")
                                            .font(.footnote)
                                    }
                                    VStack(alignment: .leading) {
                                        Text(NSNumber(value: trackers.map(\.1.count).reduce(0, +)), formatter: NumberFormatter.decimal)
                                            .font(.largeTitle.monospacedDigit())
                                            .foregroundColor(.primary)
                                        Text("Attempts blocked")
                                            .font(.footnote)
                                    }
                                    .padding(.leading)
                                    Spacer()
                                }
                                Picker("Sort", selection: $sort) {
                                    Text(verbatim: "Attempts")
                                        .foregroundColor(.white)
                                        .tag(Sleuth.Trackers.attempts)
                                    Text(verbatim: "Recent")
                                        .foregroundColor(.white)
                                        .tag(Sleuth.Trackers.recent)
                                }
                                .labelsHidden()
                                .pickerStyle(SegmentedPickerStyle())
                            }
                            .textCase(.none)
                            .padding(.vertical, 20)) {
                    ForEach(0 ..< trackers.count, id: \.self) { index in
                        NavigationLink(destination: Detail(title: trackers[index].name, dates: trackers[index].count)) {
                            Item(session: $session, name: trackers[index].name, count: trackers[index].count)
                        }
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
        }
        .onAppear(perform: update)
        .onChange(of: sort) { _ in
            update()
        }
    }
    
    private func update() {
        trackers = session.archive.trackers(sort)
    }
}
