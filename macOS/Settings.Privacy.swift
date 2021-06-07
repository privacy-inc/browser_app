import AppKit
import Combine
import Sleuth

extension Settings {
    final class Privacy: NSTabViewItem {
        private var subs = Set<AnyCancellable>()
        
        required init?(coder: NSCoder) { nil }
        override init() {
            super.init(identifier: "Privacy")
            label = "Privacy"
            
            let location = Switch(title: NSLocalizedString("Block your location", comment: ""))
            location.value.send(!cloud.archive.value.settings.location)
            location
                .value
                .sink {
                    cloud.location(!$0)
                }
                .store(in: &subs)
            
            let trackers = Switch(title: NSLocalizedString("Anti tracker protection", comment: ""))
            trackers.value.send(!cloud.archive.value.settings.trackers)
            trackers
                .value
                .sink {
                    cloud.trackers(!$0)
                }
                .store(in: &subs)
            
            let cookies = Switch(title: NSLocalizedString("Anti cookies protection", comment: ""))
            cookies.value.send(!cloud.archive.value.settings.cookies)
            cookies
                .value
                .sink {
                    cloud.cookies(!$0)
                }
                .store(in: &subs)
            
            var top = view!.topAnchor
            [location, trackers, cookies]
                .forEach {
                    view!.addSubview($0)
                    
                    $0.topAnchor.constraint(equalTo: top, constant: top == view!.topAnchor ? 20 : 0).isActive = true
                    $0.centerXAnchor.constraint(equalTo: view!.centerXAnchor).isActive = true
                    top = $0.bottomAnchor
                }
        }
    }
}
