import SwiftUI

extension Detail {
    struct Options: View {
        @Binding var session: Session
        @State private var added = false
        @Environment(\.presentationMode) private var visible
        
        var body: some View {
            if photo {
                if added {
                    HStack {
                        Text("Add to Photos")
                            .font(.footnote)
                        Spacer()
                        Image(systemName: "checkmark")
                    }
                    .padding(.horizontal)
                    .padding(.horizontal)
                    .foregroundColor(.primary)
                    .frame(height: 50)
                } else {
                    Control.Option(text: "Add to Photos", image: "photo") {
                        (try? Data(contentsOf: session.page!.url)).flatMap(UIImage.init(data:)).map {
                            UIImageWriteToSavedPhotosAlbum($0, nil, nil, nil)
                            added = true
                        }
                    }
                }
            }
            Control.Option(text: "Share", image: "square.and.arrow.up") {
                UIApplication.shared.share(session.page!.url)
            }
            Control.Option(text: "Download", image: "square.and.arrow.down") {
                (try? Data(contentsOf: session.page!.url))
                    .map {
                        $0.temporal({
                            $0.isEmpty ? "Page.webarchive" : $0.contains(".") ? $0 : $0 + ".webarchive"
                        } (session.page!.url.lastPathComponent.replacingOccurrences(of: "/", with: "")))
                    }.map(UIApplication.shared.share)
            }
            Control.Option(text: "Print", image: "printer") {
                session.print.send()
            }
            Control.Option(text: "PDF", image: "doc.plaintext") {
                session.pdf.send()
            }
        }
        
        private var photo: Bool {
            switch session.page!.url.absoluteString.components(separatedBy: ".").last!.lowercased() {
            case "png", "jpg", "jpeg", "bmp", "gif": return true
            default: return false
            }
        }
    }
}
