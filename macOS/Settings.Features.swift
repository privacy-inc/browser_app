import AppKit
import Combine
import Sleuth

extension Settings {
    final class Features: NSTabViewItem {
        private var subs = Set<AnyCancellable>()
        
        required init?(coder: NSCoder) { nil }
        override init() {
            super.init(identifier: "Features")
            label = "Features"
            
            let dark = Switch(title: NSLocalizedString("Force dark mode", comment: ""))
            dark.value.send(cloud.archive.value.settings.dark)
            dark
                .value
                .sink(receiveValue: cloud.dark)
                .store(in: &subs)
            
            let javascript = Switch(title: NSLocalizedString("JavaScript", comment: ""))
            javascript.value.send(cloud.archive.value.settings.javascript)
            javascript
                .value
                .sink(receiveValue: cloud.javascript)
                .store(in: &subs)
            
            let popups = Switch(title: NSLocalizedString("Block pop-ups", comment: ""))
            popups.value.send(!cloud.archive.value.settings.popups)
            popups
                .value
                .sink {
                    cloud.popups(!$0)
                }
                .store(in: &subs)
            
            let ads = Switch(title: NSLocalizedString("Remove ads", comment: ""))
            ads.value.send(!cloud.archive.value.settings.ads)
            ads
                .value
                .sink {
                    cloud.ads(!$0)
                }
                .store(in: &subs)
            
            let screen = Switch(title: NSLocalizedString("Remove screen blockers", comment: ""))
            screen.value.send(!cloud.archive.value.settings.screen)
            screen
                .value
                .sink {
                    cloud.screen(!$0)
                }
                .store(in: &subs)
            
            var top = view!.topAnchor
            [dark, javascript, popups, ads, screen]
                .forEach {
                    view!.addSubview($0)
                    
                    $0.topAnchor.constraint(equalTo: top, constant: top == view!.topAnchor ? 20 : 0).isActive = true
                    $0.centerXAnchor.constraint(equalTo: view!.centerXAnchor).isActive = true
                    top = $0.bottomAnchor
                }
        }
    }
}
