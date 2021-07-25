import SwiftUI

struct Trackers: View {
    @Binding var session: Session
    let trackers: [(name: String, count: [Date])]
    
    var body: some View {
        List {
            Section(header:
                        VStack {
                            Image(systemName: "shield.lefthalf.fill")
                                .font(.title2)
                                .foregroundColor(.secondary)
                                .padding(.vertical)
                            Text(NSNumber(value: trackers.count), formatter: NumberFormatter.decimal)
                                .font(.title2.monospacedDigit())
                                .foregroundColor(.primary)
                                .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
                            Text("Trackers")
                                .font(.footnote)
                                .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
                                .padding(.bottom)
                            Text(NSNumber(value: trackers.map(\.1.count).reduce(0, +)), formatter: NumberFormatter.decimal)
                                .font(.title2.monospacedDigit())
                                .foregroundColor(.primary)
                                .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
                                .padding(.top)
                            Text("Attempts blocked")
                                .font(.footnote)
                                .padding(.bottom)
                                .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
                        }
                        .textCase(.none)
                        .padding()) {
                ForEach(0 ..< trackers.count, id: \.self) {
                    Item(session: $session, name: trackers[$0].name, count: trackers[$0].count)
                }
            }
        }
    }
}
