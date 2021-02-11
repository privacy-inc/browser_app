import UIKit
import Combine
import Sleuth

extension App {
    func open(_ url: URL) {
        let current = session.page
        switch url.scheme.flatMap(Scheme.init(rawValue:)) {
        case .privacy:
            session.dismiss.send()
            UIApplication.shared.resign()
            url.absoluteString
                .dropFirst(Scheme.privacy.url.count)
                .removingPercentEncoding
                .flatMap(Defaults.engine.browse)
                .map {
                    let url: URL
                    switch $0 {
                    case let .search(search):
                        url = search
                    case let .navigate(navigate):
                        url = navigate
                    }
                    
                    session.page = .init(url: url)
                    
                    if current != nil {
                        session.browse.send(url)
                    }
                }
        case .privacy_id:
            session.dismiss.send()
            UIApplication.shared.resign()
            let id = String(url.absoluteString.dropFirst(Scheme.privacy_id.url.count))
            if id != current?.id.uuidString {
                var sub: AnyCancellable?
                sub = FileManager.page(id).receive(on: DispatchQueue.main).sink {
                    sub?.cancel()
                    var page = $0
                    page.date = .init()
                    session.page = page
                    
                    if current != nil {
                        session.browse.send(page.url)
                    }
                }
            }
        case .privacy_search:
            session.dismiss.send()
            session.page = nil
            session.type.send()
        case .privacy_forget:
            session.dismiss.send()
            UIApplication.shared.resign()
            session.forget.send()
        case .privacy_trackers:
            if session.modal != .trackers {
                UIApplication.shared.resign()
                session.dismiss.send()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    session.modal = .trackers
                }
            }
        default:
            session.dismiss.send()
            UIApplication.shared.resign()
            session.page = .init(url: url)
            
            if current != nil {
                session.browse.send(url)
            }
        }
    }
}
