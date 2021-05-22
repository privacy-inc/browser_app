import SwiftUI

struct Trackers: View {
    @Binding var session: Session
    @Environment(\.presentationMode) private var visible
    
    var body: some View {
        NavigationView {
            List {
                Section(header:
                            HStack {
                                VStack {
                                    Text(NSNumber(value: blocked.count), formatter: session.decimal)
                                        .font(.title.monospacedDigit())
                                    Text("Trackers")
                                }
                                Spacer()
                                Image(systemName: "shield.lefthalf.fill")
                                    .font(.largeTitle)
                                Spacer()
                                VStack {
                                    Text(NSNumber(value: blocked.map(\.1.count).reduce(0, +)), formatter: session.decimal)
                                        .font(.title.monospacedDigit())
                                    Text("Incidences")
                                }
                            }
                            .padding()) {
                    ForEach(0 ..< blocked.count, id: \.self) {
                        Item(session: $session, name: blocked[$0].key, blocks: blocked[$0].value)
                    }
                }
            }
            .listStyle(GroupedListStyle())
            .navigationBarTitle("Trackers blocked", displayMode: .large)
            .navigationBarItems(trailing:
                                    Button {
                                        visible.wrappedValue.dismiss()
                                    } label: {
                                        Image(systemName: "xmark")
                                            .foregroundColor(.secondary)
                                            .frame(width: 30, height: 50)
                                            .padding(.leading, 40)
                                            .contentShape(Rectangle())
                                    })
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    private var blocked: [(key: String, value: [Date])] {
        session
            .archive
            .blocked
            .sorted {
                $0.1.count == $1.1.count
                    ? $0.0.localizedCaseInsensitiveCompare($1.0) == .orderedAscending
                    : $0.1.count > $1.1.count
            }
    }
}
