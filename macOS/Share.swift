import AppKit
import Combine

final class Share: NSPopover {
    private var subs = Set<AnyCancellable>()
    
    required init?(coder: NSCoder) { nil }
    init(id: UUID) {
        super.init()
        behavior = .transient
        contentSize = .init(width: 240, height: 410)
        contentViewController = .init()
        contentViewController!.view = .init(frame: .init(origin: .zero, size: contentSize))
        
        let url = Text()
        url.stringValue = NSLocalizedString("URL", comment: "")
        
        let page = Text()
        page.stringValue = NSLocalizedString("PAGE", comment: "")
        
        let export = Text()
        export.stringValue = NSLocalizedString("EXPORT", comment: "")
        
        let urlShare = Option(title: "Share", image: "square.and.arrow.up")
        urlShare
            .click
            .sink {
                tabber
                    .items
                    .value[state: id]
                    .browse
                    .map(cloud
                            .archive
                            .value
                            .page)
                    .map(\.access.string)
                    .map { [weak self] in
                        NSSharingServicePicker(items: [$0])
                            .show(relativeTo: urlShare.bounds, of: urlShare, preferredEdge: .minY)
                        self?.close()
                    }
            }
            .store(in: &subs)
        
        let pageShare = Option(title: "Share", image: "square.and.arrow.up")
        pageShare
            .click
            .sink {
                tabber
                    .items
                    .value[state: id]
                    .browse
                    .map(cloud
                            .archive
                            .value
                            .page)
                    .flatMap(\.access.url)
                    .map { [weak self] in
                        NSSharingServicePicker(items: [$0])
                            .show(relativeTo: pageShare.bounds, of: pageShare, preferredEdge: .minY)
                        self?.close()
                    }
            }
            .store(in: &subs)
        
        let pageDownload = Option(title: "Download", image: "square.and.arrow.down")
        pageDownload
            .click
            .sink {
                tabber
                    .items
                    .value[state: id]
                    .browse
                    .map(cloud
                            .archive
                            .value
                            .page)
                    .flatMap(\.access.url?.download)
                    .map { [weak self] downloaded in
                        self?.close()
                        
                        let save = NSSavePanel()
                        save.nameFieldStringValue = downloaded.lastPathComponent
                        save.begin {
                            if $0 == .OK, let url = save.url {
                                try? Data(contentsOf: downloaded).write(to: url, options: .atomic)
                                NSWorkspace.shared.activateFileViewerSelecting([url])
                            }
                        }
                    }
            }
            .store(in: &subs)
        
        let pagePrint = Option(title: "Print", image: "printer")
        pagePrint
            .click
            .sink { [weak self] in
                self?.close()
                session.print.send(id)
            }
            .store(in: &subs)
        
        let pageSnapshot = Option(title: "Snapshot", image: "text.below.photo.fill")
        pageSnapshot
            .click
            .sink {
                
            }
            .store(in: &subs)
        
        let exportPdf = Option(title: "PDF", image: "doc.richtext")
        exportPdf
            .click
            .sink {
                
            }
            .store(in: &subs)
        
        let exportWebarchive = Option(title: "Web archive", image: "doc.zipper")
        exportWebarchive
            .click
            .sink {
                
            }
            .store(in: &subs)
        
        var top = contentViewController!.view
        [url, urlShare, page, pageShare, pageDownload, pagePrint, pageSnapshot, export, exportPdf, exportWebarchive]
            .forEach {
                contentViewController!.view.addSubview($0)
                $0.topAnchor.constraint(equalTo: top == contentViewController!.view ? top.topAnchor : top.bottomAnchor, constant:
                                            top == contentViewController!.view
                                            ? 30
                                            : top is Text
                                                ? 5
                                                : $0 is Text
                                                    ? 20
                                                    : 3).isActive = true
                top = $0
            }
        
        [url, page, export]
            .forEach {
                $0.font = .systemFont(ofSize: NSFont.preferredFont(forTextStyle: .callout).pointSize, weight: .bold)
                $0.textColor = .secondaryLabelColor
                $0.leftAnchor.constraint(equalTo: contentViewController!.view.centerXAnchor, constant: -90).isActive = true
            }
        
        [urlShare, pageShare, pageDownload, pagePrint, pageSnapshot, exportPdf, exportWebarchive]
            .forEach {
                $0.centerXAnchor.constraint(equalTo: contentViewController!.view.centerXAnchor).isActive = true
            }
    }
}
