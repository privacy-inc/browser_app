import SwiftUI
import CoreLocation

extension Settings {
    struct Location: View {
        @Binding var session: Session
        
        var body: some View {
            ScrollView {
                Image(systemName: location ? "location" : "location.slash")
                    .font(.largeTitle)
                    .foregroundColor(location ? .blue : .pink)
                    .padding(.top, 20)
                Text("Websites may request this app access to your location to provide maps, navigation or other services.")
                    .foregroundColor(.secondary)
                    .font(.callout)
                    .padding([.horizontal, .top])
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
                Text("This app will never access your location at all, but might prompt you to grant access if a website is asking for it.")
                    .foregroundColor(.secondary)
                    .font(.callout)
                    .padding([.horizontal, .top])
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
                Text("You can enable and disable this app from allowing websites to access your location directly on Settings:")
                    .foregroundColor(.secondary)
                    .font(.callout)
                    .padding([.horizontal, .top])
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
                Text("Settings > Privacy > Location")
                    .font(.callout)
                    .padding(.horizontal)
                    .padding(.top, 2)
                    .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
            }
            .navigationBarTitle("Location")
            .navigationBarItems(trailing:
                                    Button {
                                        UIApplication.shared.settings()
                                    } label: {
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 4)
                                                .foregroundColor(.accentColor)
                                            Text("Change")
                                                .foregroundColor(.primary)
                                                .font(.callout)
                                                .padding(.horizontal)
                                                .padding(.vertical, 4)
                                        }
                                    })
        }
        
        private var location: Bool {
            CLLocationManager().authorizationStatus == .authorizedWhenInUse
        }
    }
}
