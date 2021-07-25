import SwiftUI
import Sleuth

extension Tab {
    struct Options: View {
        @Binding var session: Session
        let id: UUID
        @Environment(\.presentationMode) private var visible
        
        var body: some View {
            Popup(title: "Sharing options", leading: { }) {
                List {
                    Section(
                        header: Text("URL")) {
                        Control(title: "Share", image: "square.and.arrow.up") {
                            UIApplication.shared.share(string)
                        }
                        Control(title: "Copy", image: "doc.on.doc") {
                            dismiss()
                            session.toast = .init(title: "URL copied", icon: "doc.on.doc.fill")
                            UIPasteboard.general.string = string
                        }
                    }
                    Section(
                        header: Text("Page")) {
                        Control(title: "Share", image: "square.and.arrow.up") {
                            url
                                .map(UIApplication.shared.share)
                        }
                        Control(title: "Download", image: "square.and.arrow.down") {
                            download
                                .map(UIApplication.shared.share)
                        }
                        Control(title: "Print", image: "printer") {
                            session.print.send(id)
                        }
                        Control(title: "Snapshot", image: "text.below.photo.fill") {
                            session.snapshot.send(id)
                        }
                    }
                    Section(
                        header: Text("Export")) {
                        Control(title: "PDF", image: "doc.richtext") {
                            session.pdf.send(id)
                        }
                        Control(title: "Web archive", image: "doc.zipper") {
                            session.webarchive.send(id)
                        }
                    }
                    Section(
                        header: Text("Image")) {
                        Control(title: "Add to Photos", image: "photo") {
                            dismiss()
                            url
                                .flatMap {
                                    try? Data(contentsOf: $0)
                                }
                                .flatMap(UIImage.init(data:))
                                .map {
                                    UIImageWriteToSavedPhotosAlbum($0, nil, nil, nil)
                                    session.toast = .init(title: "Added to Photos", icon: "photo")
                                }
                        }
                        .opacity(photo ? 1 : 0.3)
                    }
                    .disabled(!photo)
                }
                .listStyle(GroupedListStyle())
            }
        }
        
        private var string: String {
            session
                .items[state: id]
                .browse
                .map(session.archive.page)
                .map(\.access.value)
            ?? ""
        }
        
        private var url: URL? {
            .init(string: string)
        }
        
        private var download: URL? {
            url?.download
        }
        
        private var photo: Bool {
            switch string.components(separatedBy: ".").last!.lowercased() {
            case "png", "jpg", "jpeg", "bmp", "gif": return true
            default: return false
            }
        }
        
        private func dismiss() {
            visible.wrappedValue.dismiss()
        }
    }
}
