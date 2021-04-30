import SwiftUI
import Sleuth

struct Detail: View {
    @Binding var session: Session
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
                    Text(verbatim: session.entry!.title)
                        .fixedSize(horizontal: false, vertical: true)
                        .font(Font.title2.bold())
                        .foregroundColor(.primary)
                    Text(verbatim: session.entry!.url)
                        .fixedSize(horizontal: false, vertical: true)
                        .font(.footnote)
                        .foregroundColor(.secondary)
                    Spacer()
                }
                Spacer()
            }
            .padding(.horizontal)
            Trackers(session: $session)
            Options(session: $session)
        }
        .onReceive(session.dismiss) {
            visible.wrappedValue.dismiss()
        }
    }
}
