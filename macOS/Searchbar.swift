import AppKit
import Combine
import Sleuth

final class Searchbar: NSView {
    private(set) weak var field: Field!
    private var subs = Set<AnyCancellable>()
    
    required init?(coder: NSCoder) { nil }
    init(browser: Browser) {
        super.init(frame: .zero)
        let background = NSView()
        background.translatesAutoresizingMaskIntoConstraints = false
        background.wantsLayer = true
        background.layer!.backgroundColor = NSColor.labelColor.withAlphaComponent(0.05).cgColor
        background.layer!.cornerRadius = 6
        addSubview(background)
        
        let field = Field(browser: browser)
        self.field = field
        addSubview(field)
        
        let left = Button(icon: "chevron.left")
        let right = Button(icon: "chevron.right")
        let detail = Button(icon: "line.horizontal.3")
        
        let lupe = Button(icon: "magnifyingglass")
        let lock = Button(icon: "lock.fill")
        let warning = Button(icon: "exclamationmark.triangle.fill")
        let clockwise = Button(icon: "arrow.clockwise")
        let xmark = Button(icon: "xmark")
        
        let google = NSMenuItem(title: "Google", action: #selector(change), keyEquivalent: "")
        google.target = self
        
        let ecosia = NSMenuItem(title: "Ecosia", action: #selector(change), keyEquivalent: "")
        ecosia.target = self
        
        let engine = NSMenu()
        engine.items = [google, ecosia]
        engine.showsStateColumn = true
        
        [left, right, detail].forEach {
            $0.icon.symbolConfiguration = .init(pointSize: 16, weight: .bold)
            addSubview($0)
            $0.widthAnchor.constraint(equalToConstant: 28).isActive = true
            $0.heightAnchor.constraint(equalTo: $0.widthAnchor).isActive = true
            $0.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        }
        
        [lupe, lock, warning, clockwise, xmark].forEach {
            addSubview($0)
            $0.centerYAnchor.constraint(equalTo: field.centerYAnchor).isActive = true
            $0.widthAnchor.constraint(equalToConstant: 35).isActive = true
            $0.heightAnchor.constraint(equalToConstant: 26).isActive = true
        }
        
        [lupe, lock, warning].forEach {
            $0.leftAnchor.constraint(equalTo: field.leftAnchor).isActive = true
        }
        
        background.topAnchor.constraint(equalTo: field.topAnchor).isActive = true
        background.bottomAnchor.constraint(equalTo: field.bottomAnchor).isActive = true
        background.leftAnchor.constraint(equalTo: field.leftAnchor).isActive = true
        background.rightAnchor.constraint(equalTo: field.rightAnchor).isActive = true
        
        field.leftAnchor.constraint(equalTo: right.rightAnchor, constant: 12).isActive = true
        field.rightAnchor.constraint(equalTo: detail.leftAnchor, constant: -12).isActive = true
        field.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        left.leftAnchor.constraint(equalTo: leftAnchor, constant: 8).isActive = true
        right.leftAnchor.constraint(equalTo: left.rightAnchor).isActive = true
        detail.rightAnchor.constraint(equalTo: rightAnchor, constant: -8).isActive = true
        
        [clockwise, xmark].forEach {
            $0.rightAnchor.constraint(equalTo: field.rightAnchor).isActive = true
        }
        
        lupe.click.sink {
            google.state = Defaults.engine == .google ? .on : .off
            ecosia.state = Defaults.engine == .ecosia ? .on : .off
            engine.minimumWidth = field.frame.size.width
            engine.popUp(positioning: engine.item(at: 0), at: .init(x: field.frame.origin.x, y: 0), in: self)
        }.store(in: &subs)
        
        detail.click.sink {
            Detail(browser: browser).show(relativeTo: detail.bounds, of: detail, preferredEdge: .minY)
        }.store(in: &subs)
        
        lock.click.sink { [weak self] in
            let site = browser.page.value?.url.host ?? "this site"
            let alert = NSAlert()
            alert.messageText = NSLocalizedString("Secure Connection", comment: "")
            alert.informativeText = NSLocalizedString("Using an encrypted connection to \(site)", comment: "")
            alert.addButton(withTitle: NSLocalizedString("Accept", comment: ""))
            alert.alertStyle = .informational
            alert.icon = NSImage(systemSymbolName: "lock.fill", accessibilityDescription: nil)
            self?.window.map {
                alert.beginSheetModal(for: $0)
            }
        }.store(in: &subs)
        
        warning.click.sink { [weak self] in
            let site = browser.page.value?.url.host ?? "this site"
            let alert = NSAlert()
            alert.messageText = NSLocalizedString("Site Not Secure", comment: "")
            alert.informativeText = NSLocalizedString("Connection to \(site) is NOT encrypted", comment: "")
            alert.addButton(withTitle: NSLocalizedString("Accept", comment: ""))
            alert.alertStyle = .critical
            alert.icon = NSImage(systemSymbolName: "lock.slash.fill", accessibilityDescription: nil)
            self?.window.map {
                alert.beginSheetModal(for: $0)
            }
        }.store(in: &subs)
        
        left.click.sink {
            if browser.error.value == nil {
                if browser.backwards.value {
                    browser.previous.send()
                } else if browser.page.value != nil {
                    browser.close.send()
                }
            } else {
                browser.unerror.send()
            }
        }.store(in: &subs)
        
        right.click.sink {
            browser.next.send()
        }.store(in: &subs)
        
        clockwise.click.sink {
            browser.reload.send()
        }.store(in: &subs)
        
        xmark.click.sink {
            browser.stop.send()
        }.store(in: &subs)
        
        browser.page.sink {
            guard let url = $0?.url else {
                lupe.isHidden = false
                lock.isHidden = true
                warning.isHidden = true
                return
            }
            lupe.isHidden = true
            lock.isHidden = url.scheme != Scheme.https.rawValue
            warning.isHidden = url.scheme == Scheme.https.rawValue
        }.store(in: &subs)
        
        browser.page.combineLatest(browser.loading).sink {
            guard $0.0 != nil else {
                clockwise.isHidden = true
                xmark.isHidden = true
                return
            }
            xmark.isHidden = !$0.1
            clockwise.isHidden = $0.1
        }.store(in: &subs)
        
        browser.backwards.combineLatest(browser.error, browser.page).sink {
            left.state = $0.0 ? .on
                : $0.1 != nil ? .on
                : $0.2 != nil ? .on : .off
        }.store(in: &subs)
        
        browser.forwards.sink {
            right.state = $0 ? .on : .off
        }.store(in: &subs)
    }
    
    override func mouseUp(with: NSEvent) {
        guard
            with.clickCount >= 2,
            !field.frame.contains(convert(with.locationInWindow, from: nil))
        else {
            super.mouseUp(with: with)
            return
        }
        window?.performZoom(nil)
    }
    
    @objc private func change(_ engine: NSMenuItem) {
        switch engine.title {
        case "Google": Defaults.engine = .google
        default: Defaults.engine = .ecosia
        }
    }
}
