import SwiftUI
import Sleuth
import CoreLocation

struct Settings: View {
    @Binding var session: Session
    @State private var engine = Defaults.engine
    @Environment(\.presentationMode) private var visible
    
    var body: some View {
        ScrollView {
            HStack {
                Spacer()
                Button {
                    visible.wrappedValue.dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .foregroundColor(.secondary)
                        .font(.title3)
                        .frame(width: 60, height: 50)
                }
                .contentShape(Rectangle())
                .padding(.top)
            }
            HStack {
                Text("Search engine")
                    .font(.footnote)
                    .foregroundColor(.secondary)
                    .padding(.leading)
                Spacer()
            }
            Picker("", selection: $engine) {
                Text("Google")
                    .tag(Engine.google)
                Text("Ecosia")
                    .tag(Engine.ecosia)
            }
            .pickerStyle(SegmentedPickerStyle())
            .labelsHidden()
            .padding(.bottom)
            .padding(.horizontal)
            HStack {
                Text("Features")
                    .font(.footnote)
                    .foregroundColor(.secondary)
                    .padding(.leading)
                Spacer()
            }
            .padding(.top)
            Options()
            Control.Option(text: "Default browser", image: "magnifyingglass") {
                UIApplication.shared.settings()
            }
            .padding(.top)
            HStack {
                Text("You can make Privacy your default browser in Settings > Privacy > Default Browser App.")
                    .font(.footnote)
                    .foregroundColor(.secondary)
                    .padding(.horizontal)
                Spacer()
            }
            .padding(.bottom)
            Control.Option(text: "Location authorization", image: CLLocationManager().authorizationStatus == .authorizedWhenInUse ? "location" : "location.slash") {
                UIApplication.shared.settings()
            }
            .padding(.top)
            HStack {
                Text("Websites may want to access your location to provide maps or navigation.\n\nYou can enable and disable access to your location on Settings > Privacy > Location.\n\nPrivacy doesn't access your location at all.")
                    .font(.footnote)
                    .foregroundColor(.secondary)
                Spacer()
            }
            .padding(.horizontal)
            .padding(.bottom)
        }
        .onChange(of: engine) {
            Defaults.engine = $0
        }
        .onReceive(session.dismiss) {
            visible.wrappedValue.dismiss()
        }
    }
}
