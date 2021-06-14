import SwiftUI
import CoreLocation

extension Settings {
    struct Location: View {
        @Binding var session: Session
        
        var body: some View {
            List {
                Section(header:
                            VStack {
                                Image(systemName: location ? "location" : "location.slash")
                                    .font(.largeTitle)
                                    .foregroundColor(location ? .blue : .pink)
                                    .padding(.vertical)
                                Text("""
This app will never access your location, but may ask you to grant access if a website is requesting it.

You can change this permission on Settings > Privacy > Location.
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
            .navigationBarTitle("Location", displayMode: .inline)
        }
        
        private var location: Bool {
            CLLocationManager().authorizationStatus == .authorizedWhenInUse
        }
    }
}
