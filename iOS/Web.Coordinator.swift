import WebKit
import Combine
import Archivable
import Sleuth

extension Web {
    final class Coordinator: Webview {
        private var wrapper: Web?
        private var subs = Set<AnyCancellable>()
        
        deinit {
            print("gone")
        }

        required init?(coder: NSCoder) { nil }
        init(settings: Settings) {
            var settings = settings
            
            if !UIApplication.dark {
                settings.dark = false
            }
            
            let configuration = WKWebViewConfiguration()
            configuration.dataDetectorTypes = [.link]
            configuration.defaultWebpagePreferences.preferredContentMode = .mobile
            configuration.allowsInlineMediaPlayback = true
            configuration.ignoresViewportScaleLimits = true
            
            super.init(configuration: configuration, settings: settings)
            scrollView.keyboardDismissMode = .none
            scrollView.contentInsetAdjustmentBehavior = .always
            isOpaque = !settings.dark
            
           
            
            
            
//            view.session.previous.sink { [weak self] in
//                if self?.canGoBack == true {
//                    self?.goBack()
//                } else {
//                    view.session.section = .history
//                }
//            }.store(in: &subs)
//
//            view.session.next.sink { [weak self] in
//                self?.goForward()
//            }.store(in: &subs)
//
//            view.session.load.sink { [weak self] in
//                self?.load(view.id)
//            }.store(in: &subs)
//
//            view.session.reload.sink { [weak self] in
//                self?.reload()
//            }.store(in: &subs)
//
//            view.session.stop.sink { [weak self] in
//                self?.stopLoading()
//            }.store(in: &subs)
//
//            view.session.find.sink { [weak self] in
//                self?.select(nil)
//                self?.find($0) {
//                    guard $0.matchFound else { return }
//                    self?.evaluateJavaScript("window.getSelection().getRangeAt(0).getBoundingClientRect().top") { offset, _ in
//                        guard let offset = offset as? CGFloat, let current = self?.scrollView.contentOffset.y else { return }
//                        self?.scrollView.scrollRectToVisible(.init(x: 0, y: offset + current - 200, width: 100, height: 400), animated: true)
//                    }
//                }
//            }.store(in: &subs)
//
//            view.session.print.sink { [weak self] in
//                UIPrintInteractionController.shared.printFormatter = self?.viewPrintFormatter()
//                UIPrintInteractionController.shared.present(animated: true)
//            }.store(in: &subs)
//
//            view.session.pdf.sink { [weak self] in
//                self?.createPDF {
//                    guard
//                        case let .success(data) = $0,
//                        var name = view.session.entry?.url.components(separatedBy: "/").last
//                    else { return }
//                    if name.isEmpty {
//                        name = "Page.pdf"
//                    } else if !name.hasSuffix(".pdf") {
//                        name = {
//                            $0.count > 1 ? $0.dropLast().joined(separator: ".") : $0.first!
//                        } (name.components(separatedBy: ".")) + ".pdf"
//                    }
//                    UIApplication.shared.share(data.temporal(name))
//                }
//            }.store(in: &subs)
        }
        
        func wrap(_ wrapper: Web, _ id: UUID) {
            self.wrapper = wrapper
            
            publisher(for: \.estimatedProgress, options: .new)
                .sink { [weak self] in
                    self?.wrapper?.session.tab[progress: id] = $0
                }
                .store(in: &subs)

            publisher(for: \.isLoading, options: .new)
                .sink { [weak self] in
                    self?.wrapper?.session.tab[loading: id] = $0
                }
                .store(in: &subs)
            
            publisher(for: \.canGoForward, options: .new)
                .sink { [weak self] in
                    self?.wrapper?.session.tab[forward: id] = $0
                }
                .store(in: &subs)
            
            publisher(for: \.canGoBack, options: .new)
                .sink { [weak self] in
                    self?.wrapper?.session.tab[back: id] = $0
                }
                .store(in: &subs)
            
            publisher(for: \.title, options: .new)
                .sink {
                    $0.map { [weak self] title in
                        self?
                            .wrapper?
                            .browse
                            .map {
                                Cloud.shared.update($0, title: title)
                            }
                    }
                }
                .store(in: &subs)
            
            publisher(for: \.url, options: .new)
                .sink {
                    $0.map { [weak self] url in
                        self?
                            .wrapper?
                            .browse
                            .map {
                                Cloud.shared.update($0, url: url)
                            }
                    }
                }
                .store(in: &subs)
            
            wrapper
                .session
                .load
                .filter {
                    $0 == id
                }
                .sink { [weak self] _ in
                    self?.browse()
                }
                .store(in: &subs)
            
            wrapper
                .session
                .reload
                .filter {
                    $0 == id
                }
                .sink { [weak self] _ in
                    self?.reload()
                }
                .store(in: &subs)
            
            wrapper
                .session
                .stop
                .filter {
                    $0 == id
                }
                .sink { [weak self] _ in
                    self?.stopLoading()
                }
                .store(in: &subs)
            
            wrapper
                .session
                .back
                .filter {
                    $0 == id
                }
                .sink { [weak self] _ in
                    self?.goBack()
                }
                .store(in: &subs)
            
            wrapper
                .session
                .forward
                .filter {
                    $0 == id
                }
                .sink { [weak self] _ in
                    self?.goForward()
                }
                .store(in: &subs)
            
            if url == nil {
                browse()
            }
        }
        
        func unwrap() {
            wrapper = nil
            subs = []
        }
        
        func webView(_: WKWebView, didStartProvisionalNavigation: WKNavigation!) {
            UIApplication.shared.resign()
        }
        
        func webView(_: WKWebView, didFinish: WKNavigation!) {
            wrapper
                .map {
                    $0.session.tab[progress: $0.id] = 1
                }
            Cloud.shared.activity()
        }

        func webView(_: WKWebView, createWebViewWith: WKWebViewConfiguration, for action: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
            if (action.targetFrame == nil && action.navigationType == .other) || action.navigationType == .linkActivated {
                _ = action
                    .request
                    .url
                    .map {
                        .init(url: $0)
                    }
                    .map(load)
            }
            return nil
        }
        
        func webView(_: WKWebView, decidePolicyFor: WKNavigationAction, preferences: WKWebpagePreferences, decisionHandler: @escaping (WKNavigationActionPolicy, WKWebpagePreferences) -> Void) {
            switch Cloud.shared.policy(decidePolicyFor.request.url!) {
            case .allow:
                print("allow \(decidePolicyFor.request.url!)")
                preferences.allowsContentJavaScript = settings.javascript
                decisionHandler(.allow, preferences)
            case .external:
                print("external \(decidePolicyFor.request.url!)")
                decisionHandler(.cancel, preferences)
                UIApplication.shared.open(decidePolicyFor.request.url!)
            case .ignore:
                decisionHandler(.cancel, preferences)
            case .block:
                decisionHandler(.cancel, preferences)
            }
        }
        
        func webView(_: WKWebView, contextMenuConfigurationForElement element: WKContextMenuElementInfo, completionHandler: @escaping (UIContextMenuConfiguration?) -> Void) {
            completionHandler(.init(identifier: nil, previewProvider: nil, actionProvider: { elements in
                var elements = elements.filter {
                    guard let name = ($0 as? UIAction)?.identifier.rawValue else { return true }
                    return !(name.hasSuffix("Open") || name.hasSuffix("List"))
                }
                
                if let url = element.linkURL {
                    elements.insert(UIAction(title: NSLocalizedString("Open in new tab", comment: ""),
                                             image: UIImage(systemName: "plus.square.on.square")) { [weak self] _ in
//                        self?.wrapper.open(url)
                    }, at: 0)
                }
                
                return .init(title: "", children: elements)
            }
            ))
        }
        
        func webView(_: WKWebView, contextMenuForElement element: WKContextMenuElementInfo, willCommitWithAnimator: UIContextMenuInteractionCommitAnimating) {
            _ = element
                .linkURL
                .map {
                    .init(url: $0)
                }
                .map(load)
        }
        
        private func browse() {
            _ = wrapper
                .map {
                   $0
                        .browse
                        .map($0.session.archive.page)
                        .flatMap(\.url)
                        .map {
                            .init(url: $0)
                        }
                        .map(load)
                }
        }
    }
}
