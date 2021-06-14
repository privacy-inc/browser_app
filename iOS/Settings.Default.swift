import SwiftUI

extension Settings {
    struct Default: View {
        @Binding var session: Session
        
        var body: some View {
            List {
                Section(header:
                            VStack {
                                Image(systemName: "magnifyingglass")
                                    .font(.largeTitle)
                                    .foregroundColor(.accentColor)
                                    .padding(.vertical)
                                Text("""
You can make this app your default browser and all websites will open automatically on Privacy.
""")
                                    .foregroundColor(.secondary)
                                    .font(.callout)
                                    .fixedSize(horizontal: false, vertical: true)
                                    .padding(.vertical)
                                    .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
                            }
                            .textCase(.none)) {
                    Button {
                        UIApplication.shared.settings()
                    } label: {
                        Text("Change")
                    }
                }
            }
            .listStyle(GroupedListStyle())
            .navigationBarTitle("Default browser", displayMode: .inline)
        }
    }
}
