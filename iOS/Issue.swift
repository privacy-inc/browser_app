import SwiftUI

struct Issue: View {
    @Binding var session: Session
    
    var body: some View {
        Color.background
            .edgesIgnoringSafeArea(.all)
        VStack {
            Spacer()
            Image(systemName: "exclamationmark.triangle.fill")
                .font(Font.largeTitle.bold())
                .foregroundColor(.accentColor)
                .padding(.bottom)
            if session.page != nil {
                Text(verbatim: session.page!.url.absoluteString)
                    .multilineTextAlignment(.center)
                    .padding(.top)
                    .padding(.horizontal)
                    .padding(.bottom)
            }
            if session.error != nil {
                Text(verbatim: session.error!)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.secondary)
                    .padding(.horizontal)
                    .frame(maxWidth: 280)
            }
            Spacer()
        }
    }
}
