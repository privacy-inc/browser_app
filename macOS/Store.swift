import AppKit
import StoreKit
import Combine

final class Store: NSWindow {
    private var subs = Set<AnyCancellable>()
    
    init() {
        super.init(contentRect: .init(x: 0, y: 0, width: 400, height: 520),
                   styleMask: [.closable, .miniaturizable, .titled, .fullSizeContentView], backing: .buffered, defer: true)
        toolbar = .init()
        isReleasedWhenClosed = false
        title = NSLocalizedString("Privacy + ", comment: "")
        titlebarAppearsTransparent = true
        center()
        setFrameAutosaveName("Store")
        
        let bar = NSTitlebarAccessoryViewController()
        bar.view = Title()
        bar.layoutAttribute = .top
        addTitlebarAccessoryViewController(bar)
        
        purchases
            .loading
            .removeDuplicates()
            .combineLatest(purchases
                            .products
                            .removeDuplicates {
                                $0.first?.product == $1.first?.product
                            },
                           purchases
                            .error
                            .removeDuplicates()
            )
            .sink { [weak self] (loading: Bool, purchases: [(product: SKProduct, price: String)], error: String?) in
                if let error = error {
                    self?.contentView = Error(message: error)
                } else if loading {
                    self?.contentView = Loading()
                } else if let item = purchases.first {
                    self?.contentView = Item(product: item.product, price: item.price)
                }
            }
            .store(in: &subs)
        
        purchases.load()
    }
}
