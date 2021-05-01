import WebKit
import Combine
import Sleuth

final class Web: _Web {
    private weak var browser: Browser!
    private var destination = Destination.window
    
    required init?(coder: NSCoder) { nil }
    init(browser: Browser) {
        self.browser = browser
        
        let handler = Handler()
        let configuration = WKWebViewConfiguration()
        configuration.defaultWebpagePreferences.preferredContentMode = .desktop
        configuration.preferences.setValue(true, forKey: "fullScreenEnabled")
        configuration.userContentController.add(handler, name: "handler")
        
        if NSApp.windows.first!.effectiveAppearance == NSAppearance(named: .darkAqua) && Defaults.dark {
            configuration.userContentController.dark()
        }
        
        if Defaults.location {
            configuration.userContentController.location()
        }
        
        super.init(configuration: configuration)
        translatesAutoresizingMaskIntoConstraints = false
        setValue(false, forKey: "drawsBackground")
        customUserAgent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_6) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/14.0.2 Safari/605.1.15"
        handler.web = self
        
        publisher(for: \.estimatedProgress).sink {
            browser.progress.value = $0
        }.store(in: &subs)
        
        publisher(for: \.isLoading).sink {
            browser.loading.value = $0
        }.store(in: &subs)
        
        publisher(for: \.title)
            .compactMap {
                $0
            }
            .combineLatest(browser
                            .entry
                            .compactMap {
                                $0
                            })
            .sink {
                Synch.cloud.update($1, title: $0)
            }
            .store(in: &subs)
        
        publisher(for: \.url, options: .new)
            .compactMap {
                $0
            }
            .combineLatest(browser
                            .entry
                            .compactMap {
                                $0
                            })
            .sink {
                Synch.cloud.update($1, url: $0)
            }
            .store(in: &subs)
        
        publisher(for: \.canGoForward).sink {
            browser.forwards.value = $0
        }.store(in: &subs)
        
        browser.previous.sink { [weak self] in
            if self?.canGoBack == true {
                self?.goBack()
            } else {
                browser.close.send()
            }
        }.store(in: &subs)
        
        browser.next.sink { [weak self] in
            self?.goForward()
        }.store(in: &subs)
        
        browser.reload.sink { [weak self] in
            if let entry = browser.entry.value {
                if self?.url == nil {
                    self?.load(entry)
                } else {
                    self?.reload()
                }
            }
        }.store(in: &subs)
        
        browser.stop.sink { [weak self] in
            self?.stopLoading()
        }.store(in: &subs)
    }
    
    func webView(_: WKWebView, createWebViewWith: WKWebViewConfiguration, for action: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        if action.targetFrame == nil && action.navigationType == .other {
            action.request.url.map { new in
                switch destination {
                case .window:
                    (NSApp as? App)?.window(new)
                case .tab:
                    (window as? Window)?.newTab(new)
                case .download:
                    URLSession.shared.dataTaskPublisher(for: new)
                        .map(\.data)
                        .receive(on: DispatchQueue.main)
                        .replaceError(with: .init())
                        .sink { [weak self] in
                            (self?.window as? Window)?.save(new.lastPathComponent, data: $0)
                        }.store(in: &subs)
                    break
                }
                destination = .window
            }
        } else if action.navigationType == .linkActivated {
            action.request.url.map {
                (window as? Window)?.newTab($0)
            }
        }
        return nil
    }
    
    func webView(_: WKWebView, decidePolicyFor: WKNavigationAction, preferences: WKWebpagePreferences, decisionHandler: @escaping (WKNavigationActionPolicy, WKWebpagePreferences) -> Void) {
        switch Synch.cloud.validate(decidePolicyFor.request.url!, with: protection) {
        case .allow:
            print("allow \(decidePolicyFor.request.url!)")
            preferences.allowsContentJavaScript = javascript
            decisionHandler(.allow, preferences)
        case .external:
            print("external \(decidePolicyFor.request.url!)")
            decisionHandler(.cancel, preferences)
            NSWorkspace.shared.open(decidePolicyFor.request.url!)
        case .ignore:
            decisionHandler(.cancel, preferences)
        case .block:
            decisionHandler(.cancel, preferences)
        }
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
