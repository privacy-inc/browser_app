import AppKit
import Combine
import Sleuth

extension Settings {
    final class Javascript: NSTabViewItem {
        private var subs = Set<AnyCancellable>()
        
        required init?(coder: NSCoder) { nil }
        override init() {
            super.init(identifier: "JavaScript")
            label = "JavaScript"
            
            let javascript = Switch(title: NSLocalizedString("Scripts enabled", comment: ""))
            javascript.value.send(cloud.archive.value.settings.javascript)
            javascript
                .value
                .sink(receiveValue: cloud.javascript)
                .store(in: &subs)
            
            let timers = Switch(title: NSLocalizedString("Stop scripts when loaded", comment: ""))
            timers.value.send(!cloud.archive.value.settings.timers)
            timers
                .value
                .sink {
                    cloud.timers(!$0)
                }
                .store(in: &subs)
            
            let third = Switch(title: NSLocalizedString("Block third-party scripts", comment: ""))
            third.value.send(!cloud.archive.value.settings.third)
            third
                .value
                .sink {
                    cloud.third(!$0)
                }
                .store(in: &subs)
            
            var top = view!.topAnchor
            [javascript, timers, third]
                .forEach {
                    view!.addSubview($0)
                    
                    $0.topAnchor.constraint(equalTo: top, constant: top == view!.topAnchor ? 20 : 0).isActive = true
                    $0.centerXAnchor.constraint(equalTo: view!.centerXAnchor).isActive = true
                    top = $0.bottomAnchor
                }
        }
    }
}
