import AppKit
import Combine
import Sleuth

extension Settings {
    final class Security: NSTabViewItem {
        private var subs = Set<AnyCancellable>()
        
        required init?(coder: NSCoder) { nil }
        override init() {
            super.init(identifier: "Security")
            label = "Security"
            
            let settings = cloud.archive.value.settings
            
            let title = Text()
            title.font = .preferredFont(forTextStyle: .callout)
            title.textColor = .secondaryLabelColor
            title.stringValue = "Reopen your tabs\nfor changes to become effective"
            
            let http = Switch(title: NSLocalizedString("Force secure connections", comment: ""))
            http.value.send(!settings.http)
            http
                .value
                .sink {
                    cloud.http(!$0)
                }
                .store(in: &subs)
            
            var top = view!.topAnchor
            [title, http]
                .forEach {
                    view!.addSubview($0)
                    
                    $0.topAnchor.constraint(equalTo: top, constant: top == view!.topAnchor || top == title.bottomAnchor ? 20 : 5).isActive = true
                    $0.centerXAnchor.constraint(equalTo: view!.centerXAnchor).isActive = true
                    top = $0.bottomAnchor
                }
        }
    }
}
