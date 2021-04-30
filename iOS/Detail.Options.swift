import SwiftUI
import Sleuth

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
                        session
                            .access
                            .flatMap {
                                try? Data(contentsOf: $0)
                            }
                            .flatMap(UIImage.init(data:))
                            .map {
                                UIImageWriteToSavedPhotosAlbum($0, nil, nil, nil)
                                added = true
                            }
                    }
                }
            }
            Control.Option(text: "Share", image: "square.and.arrow.up") {
                session
                    .access
                    .map(UIApplication.shared.share)
            }
            Control.Option(text: "Download", image: "square.and.arrow.down") {
                session
                    .access
                    .flatMap { access in
                        (try? Data(contentsOf: access))
                            .map {
                                $0.temporal({
                                    $0.isEmpty ? "Page.webarchive" : $0.contains(".") ? $0 : $0 + ".webarchive"
                                } (access.lastPathComponent.replacingOccurrences(of: "/", with: "")))
                            }
                    }
                    .map(UIApplication.shared.share)
            }
            Control.Option(text: "Print", image: "printer") {
                session.print.send()
            }
            Control.Option(text: "PDF", image: "doc.plaintext") {
                session.pdf.send()
            }
        }
        
        private var photo: Bool {
            session
                .access
                .map {
                    switch $0.absoluteString.components(separatedBy: ".").last!.lowercased() {
                    case "png", "jpg", "jpeg", "bmp", "gif": return true
                    default: return false
                    }
                } ?? false
        }
    }
}
