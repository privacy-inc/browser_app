import AppKit
import Combine
import Sleuth

extension New {
    final class Bookmarks: List {
        required init?(coder: NSCoder) { nil }
        override init(session: Session, id: UUID) {
            super.init(session: session, id: id)
            cloud
                .archive
                .map(\.bookmarks)
                .removeDuplicates()
                .map {
                    $0
                        .enumerated()
                        .map { (index: Int, page: Page) in
                            .init(
                                id: index,
                                string: .make {
                                    if !page.title.isEmpty {
                                        $0.append(.make(page.title,
                                                        font: .preferredFont(forTextStyle: .body),
                                                        color: .labelColor))
                                    }
                                    if !page.access.short.isEmpty {
                                        if !page.title.isEmpty {
                                            $0.linebreak()
                                        }
                                        $0.append(.make(page.access.short,
                                                        font: .preferredFont(forTextStyle: .callout),
                                                        color: .secondaryLabelColor))
                                    }
                                })
                        }
                }
                .subscribe(info)
                .store(in: &subs)
            
            selected
                .compactMap {
                    $0
                }
                .sink {
                    cloud
                        .open($0) {
                            session.tab.browse(id, $0)
                        }
                }
                .store(in: &subs)
        }
        
        override func delete() {
            highlighted
                .value
                .map(cloud.remove(bookmark:))
        }
    }
}
