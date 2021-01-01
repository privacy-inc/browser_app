import SwiftUI

struct Detail: View {
    @Binding var session: Session
//    @AppStorage(Defaults.Key.settings_sound.rawValue) private var sound = true
//    @AppStorage(Defaults.Key.settings_vibrate.rawValue) private var vibrate = true
    @Environment(\.presentationMode) private var visible
    
    var body: some View {
        ScrollView {
            HStack {
                Spacer()
                Button {
                    visible.wrappedValue.dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .font(.callout)
                        .foregroundColor(.secondary)
                        .frame(width: 60, height: 50)
                }
                .contentShape(Rectangle())
                .padding(.top)
            }
            HStack {
                VStack(alignment: .leading) {
                    Text(verbatim: session.page!.title)
                        .fixedSize(horizontal: false, vertical: true)
                        .font(Font.title2.bold())
                        .foregroundColor(.primary)
                    Text(verbatim: session.page!.url.absoluteString)
                        .fixedSize(horizontal: false, vertical: true)
                        .font(.footnote)
                        .foregroundColor(.secondary)
                    Spacer()
                }
                Spacer()
            }
            .padding(.horizontal)
            Trackers(session: $session)
            Find(session: $session)
            Options(session: $session)
        }
    }
}
