import WebKit
import Sleuth

final class Web: _Web {
    private var destination = Destination.window
    
    required init?(coder: NSCoder) { nil }
    init(browser: Browser) {
        let configuration = WKWebViewConfiguration()
        configuration.applicationNameForUserAgent = "Safari/605"
        configuration.defaultWebpagePreferences.preferredContentMode = .desktop
        
        if NSApp.windows.first!.effectiveAppearance == NSAppearance(named: .darkAqua) && Defaults.dark {
            configuration.userContentController.dark()
        }
        
        super.init(browser: browser, configuration: configuration)
        translatesAutoresizingMaskIntoConstraints = false
        setValue(false, forKey: "drawsBackground")
    }
    
    override func popup(_ url: URL) {
        switch destination {
        case .window:
            (NSApp as? App)?.window(url)
        case .tab:
            (window as? Window)?.newTab(url)
        case .download:
            URLSession.shared.dataTaskPublisher(for: url)
                .map(\.data)
                .receive(on: DispatchQueue.main)
                .replaceError(with: .init())
                .sink { [weak self] in
                    (self?.window as? Window)?.save(url.lastPathComponent, data: $0)
                }.store(in: &subs)
            break
        }
        destination = .window
    }
    
    override func external(_ url: URL) {
        NSWorkspace.shared.open(url)
    }
    
    override func blocked(_ domain: String) {
        (NSApp as! App).blocked.value.insert(domain)
    }
    
    override func willOpenMenu(_ menu: NSMenu, with: NSEvent) {
        menu.items.first { $0.identifier?.rawValue == "WKMenuItemIdentifierOpenLinkInNewWindow" }.map { item in
            let newTab = NSMenuItem(title: NSLocalizedString("Open Link in New Tab", comment: ""), action: #selector(tabbed), keyEquivalent: "")
            newTab.target = self
            newTab.representedObject = item
            menu.items = [newTab, .separator()] + menu.items
            
            menu.items.first { $0.identifier?.rawValue == "WKMenuItemIdentifierDownloadLinkedFile" }.map {
                $0.target = self
                $0.action = #selector(download)
                $0.representedObject = item
            }
        }
        menu.items.first { $0.identifier?.rawValue == "WKMenuItemIdentifierOpenImageInNewWindow" }.map { item in
            let newTab = NSMenuItem(title: NSLocalizedString("Open Image in New Tab", comment: ""), action: #selector(tabbed), keyEquivalent: "")
            newTab.target = self
            newTab.representedObject = item
            menu.insertItem(newTab, at: menu.items.firstIndex(of: item)!)
            
            menu.items.first { $0.identifier?.rawValue == "WKMenuItemIdentifierDownloadImage" }.map {
                $0.target = self
                $0.action = #selector(download)
                $0.representedObject = item
            }
        }
    }
    
    @objc private func tabbed(_ item: NSMenuItem) {
        destination = .tab
        item.synth()
    }
    
    @objc private func download(_ item: NSMenuItem) {
        destination = .download
        item.synth()
    }
}
