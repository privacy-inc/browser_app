import AppKit
import Combine

final class Share: NSPopover {
    private var subs = Set<AnyCancellable>()
    
    required init?(coder: NSCoder) { nil }
    init(id: UUID) {
        super.init()
        behavior = .transient
        contentSize = .init(width: 300, height: 400)
        contentViewController = .init()
        contentViewController!.view = .init(frame: .init(origin: .zero, size: contentSize))
        
        let url = Text()
        url.stringValue = NSLocalizedString("URL", comment: "")
        url.font = .systemFont(ofSize: NSFont.preferredFont(forTextStyle: .callout).pointSize, weight: .bold)
        url.textColor = .secondaryLabelColor
        
        let urlShare = Option(title: "Share", image: "square.and.arrow.up")
        urlShare
            .click
            .sink {
                
            }
            .store(in: &subs)
        
        [url, urlShare]
            .forEach {
                contentViewController!.view.addSubview($0)
            }
        
        [url]
            .forEach {
                $0.leftAnchor.constraint(equalTo: contentViewController!.view.centerXAnchor, constant: -80).isActive = true
            }
        
        [urlShare]
            .forEach {
                $0.centerXAnchor.constraint(equalTo: contentViewController!.view.centerXAnchor).isActive = true
            }
        
        url.topAnchor.constraint(equalTo: contentViewController!.view.topAnchor, constant: 40).isActive = true
        urlShare.topAnchor.constraint(equalTo: url.bottomAnchor, constant: 10).isActive = true
    }
}
/*

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
                archive
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

 */
