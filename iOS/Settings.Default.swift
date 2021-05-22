import SwiftUI
import CoreLocation

extension Settings {
    struct Default: View {
        @Binding var session: Session
        
        var body: some View {
            ScrollView {
                Text("You can make Privacy your default browser.")
                    .foregroundColor(.secondary)
                    .font(.callout)
                    .padding([.horizontal, .top])
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
                Text("All websites will open automatically on this app.")
                    .foregroundColor(.secondary)
                    .font(.callout)
                    .padding([.horizontal, .top])
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
                Text("You can enable this directly on Settings:")
                    .foregroundColor(.secondary)
                    .font(.callout)
                    .padding([.horizontal, .top])
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
                Text("Settings > Privacy > Default Browser App")
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
                                                .foregroundColor(.white)
                                                .font(.footnote)
                                                .padding(.horizontal)
                                                .padding(.vertical, 6)
                                        }
                                    })
        }
    }
}
