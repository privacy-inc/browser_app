import SwiftUI

extension Settings {
    struct Default: View {
        @Binding var session: Session
        
        var body: some View {
            ScrollView {
                Image(systemName: "magnifyingglass")
                    .font(.largeTitle)
                    .foregroundColor(.accentColor)
                    .padding(.top, 20)
                Text("You can make Privacy your default browser.")
                    .foregroundColor(.secondary)
                    .font(.callout)
                    .padding([.horizontal, .top])
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
                Text("All websites will open automatically on this app.")
                    .foregroundColor(.secondary)
                    .font(.callout)
                    .padding(.horizontal)
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
                Text("You can enable this directly on Settings:")
                    .foregroundColor(.secondary)
                    .font(.callout)
                    .padding(.horizontal)
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
                Text("Settings > Privacy > Default Browser App")
                    .font(.callout)
                    .padding(.horizontal)
                    .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
            }
            .navigationBarTitle("Default browser")
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
