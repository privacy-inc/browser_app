import AppKit
import StoreKit
import Combine
import Sleuth

extension Store {
    final class Item: NSVisualEffectView {
        private var subs = Set<AnyCancellable>()
        
        required init?(coder: NSCoder) { nil }
        init(product: SKProduct, price: String) {
            super.init(frame: .zero)
            
            let item = Purchases.Item(rawValue: product.productIdentifier)!

            let image = Image(named: item.image)
            addSubview(image)
            
            let name = Text()
            name.font = .preferredFont(forTextStyle: .largeTitle)
            name.stringValue = item.title
            addSubview(name)
            
            let icon = Image(icon: item.icon)
            icon.symbolConfiguration = .init(textStyle: .largeTitle)
            icon.contentTintColor = .labelColor
            addSubview(icon)
            
            let subtitle = Text()
            subtitle.font = .preferredFont(forTextStyle: .callout)
            subtitle.stringValue = item.subtitle
            subtitle.textColor = .secondaryLabelColor
            addSubview(subtitle)
            
            image.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 30).isActive = true
            image.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
            
            name.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 20).isActive = true
            name.centerXAnchor.constraint(equalTo: centerXAnchor, constant: -10).isActive = true
            
            icon.leftAnchor.constraint(equalTo: name.rightAnchor, constant: 5).isActive = true
            icon.centerYAnchor.constraint(equalTo: name.centerYAnchor).isActive = true
            
            subtitle.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 5).isActive = true
            subtitle.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
            
            if Defaults.premium {
                let icon = Image(icon: "checkmark.circle.fill")
                icon.symbolConfiguration = .init(pointSize: 40, weight: .regular)
                icon.contentTintColor = .controlAccentColor
                addSubview(icon)
                
                icon.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -120).isActive = true
                icon.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
            } else {
                let value = Text()
                value.stringValue = price
                value.font = .font(style: .body, weight: .medium)
                addSubview(value)
                
                let purchase = Control.Capsule(title: "Purchase")
                purchase
                    .click
                    .sink {
                        purchases.purchase(product)
                    }
                    .store(in: &subs)
                addSubview(purchase)
                
                let why = Option(title: "Why In-App Purchases", image: "questionmark.circle.fill")
                why
                    .click
                    .sink {
                        NSApp.why()
                    }
                    .store(in: &subs)
                addSubview(why)
                
                let alternatives = Option(title: "Alternatives", image: "arrow.rectanglepath")
                alternatives
                    .click
                    .sink {
                        NSApp.alternatives()
                    }
                    .store(in: &subs)
                addSubview(alternatives)
                
                value.topAnchor.constraint(equalTo: subtitle.bottomAnchor, constant: 30).isActive = true
                value.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
                
                purchase.topAnchor.constraint(equalTo: value.bottomAnchor, constant: 8).isActive = true
                purchase.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
                
                why.bottomAnchor.constraint(equalTo: alternatives.topAnchor).isActive = true
                why.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
                
                alternatives.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -40).isActive = true
                alternatives.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
            }
        }
    }
}
