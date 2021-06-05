import AppKit
import Combine

final class Segmented: NSView {
    let select = PassthroughSubject<Int, Never>()
    private var subs = Set<AnyCancellable>()
    
    private weak var indicator: NSView!
    private weak var indicatorCenter: NSLayoutConstraint? {
        didSet {
            oldValue?.isActive = false
            indicatorCenter!.isActive = true
        }
    }
    
    required init?(coder: NSCoder) { nil }
    init(items: [String]) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        wantsLayer = true
        layer!.backgroundColor = NSColor.unemphasizedSelectedContentBackgroundColor.cgColor
        layer!.cornerRadius = 6
        
        let indicator = NSView()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.wantsLayer = true
        indicator.layer!.backgroundColor = NSColor.controlAccentColor.cgColor
        indicator.layer!.cornerRadius = layer!.cornerRadius
        addSubview(indicator)
        self.indicator = indicator
        
        var left = leftAnchor
        items
            .map(Item.init)
            .enumerated()
            .forEach { (index: Int, item: Item) in
                item
                    .click
                    .map {
                        index
                    }
                    .subscribe(select)
                    .store(in: &subs)
                addSubview(item)
                
                item.leftAnchor.constraint(equalTo: left).isActive = true
                item.topAnchor.constraint(equalTo: topAnchor).isActive = true
                item.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
                item.widthAnchor.constraint(equalTo: indicator.widthAnchor).isActive = true
                left = item.rightAnchor
            }
        
        heightAnchor.constraint(equalToConstant: 28).isActive = true
        
        indicator.topAnchor.constraint(equalTo: topAnchor).isActive = true
        indicator.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        indicator.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1 / CGFloat(items.count)).isActive = true
        
        layoutSubtreeIfNeeded()
        
        select
            .sink { [weak self] in
                self?.center(index: $0)
            }
            .store(in: &subs)
    }
    
    private func center(index: Int) {
        subviews
            .compactMap {
                $0 as? Item
            }
            .enumerated()
            .forEach {
                $0.1.label.textColor = $0.0 == index ? .white : .secondaryLabelColor
            }
        indicatorCenter = indicator.centerXAnchor.constraint(equalTo: subviews.filter { $0 is Item }[index].centerXAnchor)
        NSAnimationContext.runAnimationGroup {
            $0.duration = 0.35
            $0.allowsImplicitAnimation = true
            layoutSubtreeIfNeeded()
        }
    }
}
