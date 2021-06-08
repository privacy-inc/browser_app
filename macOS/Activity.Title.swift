import AppKit
import Combine

extension Activity {
    final class Title: NSView {
        private var subscription: AnyCancellable?
        
        required init?(coder: NSCoder) { nil }
        init() {
            super.init(frame: .zero)
            let since = Text()
            since.font = .preferredFont(forTextStyle: .callout)
            since.textColor = .secondaryLabelColor
            addSubview(since)
            
            let now = Text()
            now.font = .preferredFont(forTextStyle: .callout)
            now.textColor = .secondaryLabelColor
            now.stringValue = NSLocalizedString("Now", comment: "")
            addSubview(now)
            
            subscription = cloud
                .archive
                .compactMap(\.since)
                .removeDuplicates()
                .sink {
                    since.stringValue = RelativeDateTimeFormatter().string(from: $0)
                }
            
            since.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            since.leftAnchor.constraint(equalTo: leftAnchor, constant: 30).isActive = true
            
            now.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            now.rightAnchor.constraint(equalTo: rightAnchor, constant: -30).isActive = true
        }
    }
}
