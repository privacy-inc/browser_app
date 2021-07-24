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
            
            let http = Switch(title: NSLocalizedString("Force secure connections", comment: ""))
            http.value.send(!cloud.archive.value.settings.http)
            http
                .value
                .sink {
                    cloud.http(!$0)
                }
                .store(in: &subs)
            view!.addSubview(http)
            
            let title = Text()
            title.font = .preferredFont(forTextStyle: .body)
            title.textColor = .secondaryLabelColor
            title.stringValue = """
This will force all websites to use an encrypted connection with SSL and over HTTPS.

But it will fail to open websites that only support insecure connections over HTTP, this sometimes happens on old websites.
"""
            title.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
            view!.addSubview(title)
            
            http.topAnchor.constraint(equalTo: view!.topAnchor, constant: 20).isActive = true
            http.centerXAnchor.constraint(equalTo: view!.centerXAnchor).isActive = true
            
            title.topAnchor.constraint(equalTo: http.bottomAnchor, constant: 10).isActive = true
            title.leftAnchor.constraint(equalTo: http.leftAnchor, constant: -60).isActive = true
            title.rightAnchor.constraint(equalTo: http.rightAnchor, constant: 60).isActive = true
        }
    }
}
