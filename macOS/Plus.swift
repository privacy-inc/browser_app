import AppKit
import Sleuth
import Combine

final class Plus: NSWindow {
    private var subs = Set<AnyCancellable>()
    
    init() {
        super.init(contentRect: .init(x: 0, y: 0, width: 400, height: 650),
                   styleMask: [.closable, .titled, .fullSizeContentView], backing: .buffered, defer: false)
        toolbar = .init()
        title = NSLocalizedString("Privacy Plus", comment: "")
        titlebarAppearsTransparent = true
        collectionBehavior = .fullScreenNone
        isReleasedWhenClosed = false
        center()
        
        let purchases = Purchases()
        
        let restore = Tool(title: NSLocalizedString("Restore Purchases", comment: ""), icon: "questionmark")
        restore.click.sink {
            purchases.restore()
        }.store(in: &subs)
        
        let why = Tool(title: NSLocalizedString("Why In-App Purchases", comment: ""), icon: "arrow.clockwise.circle.fill")
        why.click.sink {
            purchases.restore()
        }.store(in: &subs)
        
        let alternatives = Tool(title: NSLocalizedString("Alternatives", comment: ""), icon: "arrow.rectanglepath")
        alternatives.click.sink {
            purchases.restore()
        }.store(in: &subs)
        
        purchases.loading.combineLatest(purchases.products, purchases.error).sink { [weak self] in
            guard let self = self else { return }
            self.contentView!.subviews.forEach { $0.removeFromSuperview() }
            if let error = $0.2 {
                let text = Text()
                text.stringValue = error
                text.textColor = .secondaryLabelColor
                text.font = .systemFont(ofSize: 16, weight: .regular)
                text.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
                
                self.contentView!.addSubview(text)
                text.topAnchor.constraint(equalTo: self.contentView!.safeAreaLayoutGuide.topAnchor, constant: 40).isActive = true
                text.leftAnchor.constraint(equalTo: self.contentView!.safeAreaLayoutGuide.leftAnchor, constant: 40).isActive = true
                text.rightAnchor.constraint(lessThanOrEqualTo: self.contentView!.safeAreaLayoutGuide.rightAnchor, constant: -40).isActive = true
            } else if $0.0 || $0.1.isEmpty {
                let text = Text()
                text.stringValue = NSLocalizedString("Loading...", comment: "")
                text.textColor = .tertiaryLabelColor
                text.font = .systemFont(ofSize: 18, weight: .regular)
                self.contentView!.addSubview(text)
                
                text.centerXAnchor.constraint(equalTo: self.contentView!.centerXAnchor).isActive = true
                text.centerYAnchor.constraint(equalTo: self.contentView!.centerYAnchor).isActive = true
            } else if let product = $0.1.first {
                let item = Purchases.Item(rawValue: product.0.productIdentifier)!
                let base = NSView()
                base.translatesAutoresizingMaskIntoConstraints = false
                base.wantsLayer = true
                base.layer!.backgroundColor = NSColor.labelColor.withAlphaComponent(0.05).cgColor
                base.layer!.cornerRadius = 18
                
                let image = NSImageView(image: NSImage(named: item.image)!)
                image.translatesAutoresizingMaskIntoConstraints = false
                base.addSubview(image)
                
                let title = Text()
                title.font = .systemFont(ofSize: 25, weight: .bold)
                title.stringValue = item.title
                base.addSubview(title)
                
                let subtitle = Text()
                subtitle.font = .systemFont(ofSize: 14, weight: .regular)
                subtitle.stringValue = item.subtitle
                subtitle.textColor = .tertiaryLabelColor
                subtitle.alignment = .center
                subtitle.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
                base.addSubview(subtitle)
                
                [base, restore, why, alternatives].forEach {
                    self.contentView!.addSubview($0)
                    $0.leftAnchor.constraint(equalTo: self.contentView!.safeAreaLayoutGuide.leftAnchor, constant: 20).isActive = true
                    $0.rightAnchor.constraint(equalTo: self.contentView!.safeAreaLayoutGuide.rightAnchor, constant: -20).isActive = true
                }
                
                if Defaults.premium {
                    let image = NSImageView(image: NSImage(systemSymbolName: "checkmark.shield.fill", accessibilityDescription: nil)!)
                    image.translatesAutoresizingMaskIntoConstraints = false
                    image.symbolConfiguration = .init(textStyle: .largeTitle)
                    base.addSubview(image)
                    
                    image.topAnchor.constraint(equalTo: subtitle.bottomAnchor, constant: 40).isActive = true
                    image.centerXAnchor.constraint(equalTo: base.centerXAnchor).isActive = true
                } else {
                    let price = Text()
                    price.stringValue = product.1
                    price.font = .systemFont(ofSize: 14, weight: .bold)
                    base.addSubview(price)
                    
                    price.topAnchor.constraint(equalTo: subtitle.bottomAnchor, constant: 40).isActive = true
                    price.centerXAnchor.constraint(equalTo: base.centerXAnchor).isActive = true
                    
                    let purchase = Capsule(title: NSLocalizedString("Purchase", comment: ""))
                    purchase.click.sink {
                        purchases.purchase(product.0)
                    }.store(in: &self.subs)
                    base.addSubview(purchase)
                    purchase.topAnchor.constraint(equalTo: price.bottomAnchor, constant: 6).isActive = true
                    purchase.centerXAnchor.constraint(equalTo: base.centerXAnchor).isActive = true
                    purchase.widthAnchor.constraint(equalToConstant: 150).isActive = true
                }
                
                base.topAnchor.constraint(equalTo: self.contentView!.safeAreaLayoutGuide.topAnchor).isActive = true
                base.heightAnchor.constraint(equalToConstant: 400).isActive = true
                
                image.topAnchor.constraint(equalTo: base.topAnchor, constant: 40).isActive = true
                image.centerXAnchor.constraint(equalTo: base.centerXAnchor).isActive = true
                
                title.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 20).isActive = true
                title.centerXAnchor.constraint(equalTo: base.centerXAnchor).isActive = true
                
                subtitle.topAnchor.constraint(equalTo: title.bottomAnchor).isActive = true
                subtitle.centerXAnchor.constraint(equalTo: base.centerXAnchor).isActive = true
                subtitle.leftAnchor.constraint(greaterThanOrEqualTo: base.leftAnchor, constant: 40).isActive = true
                subtitle.rightAnchor.constraint(lessThanOrEqualTo: base.rightAnchor, constant: -40).isActive = true
                
                restore.topAnchor.constraint(equalTo: base.bottomAnchor, constant: 20).isActive = true
                why.topAnchor.constraint(equalTo: restore.bottomAnchor, constant: 4).isActive = true
                alternatives.topAnchor.constraint(equalTo: why.bottomAnchor, constant: 4).isActive = true
            }
        }.store(in: &subs)
        
        purchases.load()
    }
}
