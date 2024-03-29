import AppKit
import Combine

extension New {
    final class History: List {
        required init?(coder: NSCoder) { nil }
        override init(session: Session, id: UUID) {
            super.init(session: session, id: id)
            cloud
                .archive
                .map(\.browses)
                .removeDuplicates()
                .map { browses in
                    browses
                        .map { browse in
                            .init(
                                id: browse.id,
                                domain: browse.page.access.short,
                                string: .make {
                                    if !browse.page.title.isEmpty {
                                        $0.append(.make(browse.page.title,
                                                        font: .preferredFont(forTextStyle: .body),
                                                        color: .labelColor))
                                        $0.linebreak()
                                    }
                                    $0.append(.make(browse.page.access.short + " - " + RelativeDateTimeFormatter().string(from: browse.date),
                                                    font: .preferredFont(forTextStyle: .callout),
                                                    color: .secondaryLabelColor))
                                },
                                first: browse == browses.first)
                        }
                }
                .sink { [weak self] in
                    self?.info.send($0)
                }
                .store(in: &subs)
            
            selected
                .compactMap {
                    $0
                }
                .sink {
                    cloud.revisit($0)
                    session.tab.browse(id, $0)
                }
                .store(in: &subs)
        }
        
        override func delete() {
            highlighted
                .value
                .map(cloud.remove(browse:))
        }
    }
}
