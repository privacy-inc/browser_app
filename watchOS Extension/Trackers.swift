import SwiftUI

struct Trackers: View {
    @Binding var session: Session
    let trackers: [(name: String, count: [Date])]
    
    var body: some View {
        List {
            Section(header:
                        VStack {
                            Image(systemName: "shield.lefthalf.fill")
                                .font(.title)
                                .foregroundColor(.accentColor)
                                .padding(.vertical)
                            Text(NSNumber(value: trackers.count), formatter: session.decimal)
                                .font(.title.monospacedDigit())
                                .foregroundColor(.pink)
                                .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
                            Text("Trackers")
                                .font(.callout)
                                .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
                            Text(NSNumber(value: trackers.map(\.1.count).reduce(0, +)), formatter: session.decimal)
                                .font(.title.monospacedDigit())
                                .foregroundColor(.pink)
                                .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
                                .padding(.top)
                            Text("Incidences")
                                .font(.callout)
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
