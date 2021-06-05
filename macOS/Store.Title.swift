import AppKit
import Combine

extension Store {
    final class Title: NSView {
        private var subs = Set<AnyCancellable>()
        
        required init?(coder: NSCoder) { nil }
        init() {
            super.init(frame: .zero)
            
            let restore = Control.Title(title: "Restore purchases")
            restore
                .click
                .sink {
                    purchases.restore()
                }
                .store(in: &subs)
            addSubview(restore)
            
            purchases
                .loading
                .removeDuplicates()
                .combineLatest(purchases
                                .error
                                .removeDuplicates())
                .sink { (loading: Bool, error: String?) in
                    restore.isHidden = loading || error != nil
                }
                .store(in: &subs)
            
            restore.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            restore.rightAnchor.constraint(equalTo: rightAnchor, constant: -5).isActive = true
        }
    }
}
