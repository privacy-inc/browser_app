import SwiftUI
import Sleuth

extension Trackers {
    struct List: View {
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
                VStack {
                    Image(systemName: "shield.lefthalf.fill")
                        .font(.largeTitle)
                    Text("Trackers blocked")
                        .font(Font.footnote.bold())
                        .padding(.vertical)
                }
                ForEach(Share.blocked, id: \.self) { tracker in
                    Rectangle()
                        .fill(Color(.quaternarySystemFill))
                        .frame(height: 1)
                        .padding(.horizontal)
                    HStack {
                        Text(tracker)
                            .font(.callout)
                            .foregroundColor(.secondary)
                        Spacer()
                    }
                    .padding(.horizontal)
                }
            }
            .onReceive(session.dismiss) {
                visible.wrappedValue.dismiss()
            }
        }
    }
}
