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
                .foregroundColor(.secondary)
        }) {
            List {
                Section(header:
                            VStack {
                                HStack {
                                    Spacer()
                                    Text(NSNumber(value: trackers.count), formatter: NumberFormatter.decimal)
                                        .foregroundColor(.primary)
                                        .font(.largeTitle.monospacedDigit())
                                    + Text("\nTrackers")
                                        .font(.footnote)
                                    Text(NSNumber(value: trackers.map(\.1.count).reduce(0, +)), formatter: NumberFormatter.decimal)
                                        .foregroundColor(.primary)
                                        .font(.largeTitle.monospacedDigit())
                                    + Text("\nAttempts blocked")
                                        .font(.footnote)
                                }
                                .multilineTextAlignment(.trailing)
                                .padding(.trailing)
                                Picker("Sort", selection: $sort) {
                                    Text(verbatim: "Attempts")
                                        .tag(Sleuth.Trackers.attempts)
                                    Text(verbatim: "Recent")
                                        .tag(Sleuth.Trackers.recent)
                                }
                                .labelsHidden()
                                .pickerStyle(SegmentedPickerStyle())
                            }
                            .textCase(.none)
                            .padding(.vertical, 20)) {
                    ForEach(0 ..< trackers.count, id: \.self) { index in
                        NavigationLink(destination: Detail(title: trackers[index].name, dates: trackers[index].count)) {
                            switch sort {
                            case .attempts:
                                Attempts(name: trackers[index].name, count: trackers[index].count.count)
                                    .padding(.vertical, 5)
                                    .multilineTextAlignment(.trailing)
                                    .frame(maxWidth: .greatestFiniteMagnitude, alignment: .trailing)
                            case .recent:
                                Recent(name: trackers[index].name, last: trackers[index].count.last ?? .init())
                                    .padding(.vertical, 5)
                            }
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
