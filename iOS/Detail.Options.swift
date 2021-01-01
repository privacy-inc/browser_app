import SwiftUI

extension Detail {
    struct Options: View {
        @Binding var session: Session
        @State private var photo = false
        @State private var done = false
        @Environment(\.presentationMode) private var visible
        
        var body: some View {
            if photo {
                Item(text: "Add to Photos", image: "photo") {
                    (try? Data(contentsOf: session.page!.url)).flatMap(UIImage.init(data:)).map {
                        UIImageWriteToSavedPhotosAlbum($0, nil, nil, nil)
                        success()
                    }
                }
            }
            Item(text: "Edit URL", image: "pencil") {
                visible.wrappedValue.dismiss()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    session.text.send(session.page!.url.absoluteString)
                    session.type.send()
                }
            }
            .onAppear {
                switch session.page!.url.pathExtension.lowercased() {
                case "png", "jpg", "jpeg", "bmp", "gif": photo = true
                default: break
                }
            }
            Item(text: "Copy URL", image: "doc.on.doc") {
                UIPasteboard.general.string = session.page!.url.absoluteString
                success()
            }
            Item(text: "Share", image: "square.and.arrow.up") {
                UIApplication.shared.share(session.page!.url)
            }
            Item(text: "Download", image: "square.and.arrow.down") {
                (try? Data(contentsOf: session.page!.url))
                    .map {
                        $0.temporal({
                            $0.isEmpty ? "Page.webarchive" : $0.contains(".") ? $0 : $0 + ".webarchive"
                        } (session.page!.url.lastPathComponent.replacingOccurrences(of: "/", with: "")))
                    }.map(UIApplication.shared.share)
            }
            Item(text: "Print", image: "printer") {
                session.print.send()
            }
            Item(text: "PDF", image: "doc.plaintext") {
                session.pdf.send()
            }
            HStack {
                Spacer()
                Image(systemName: "checkmark.circle.fill")
                    .font(Font.title.bold())
                    .foregroundColor(.accentColor)
                    .padding(.vertical)
                Spacer()
                    .frame(width: 5)
                Text("Done")
                    .bold()
                    .foregroundColor(.accentColor)
                Spacer()
            }
            .opacity(done ? 1 : 0)
        }
        
        private func success() {
            withAnimation(.easeInOut(duration: 0.3)) {
                done = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                withAnimation(.easeInOut(duration: 0.3)) {
                    done = false
                }
            }
        }
    }
}
