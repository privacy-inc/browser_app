import WebKit
import Combine
import Archivable
import Sleuth

extension Web {
    final class Coordinator: _Web {
        private let view: Web
        
        required init?(coder: NSCoder) { nil }
        init(view: Web) {
            let configuration = WKWebViewConfiguration()
            configuration.dataDetectorTypes = [.link]
            configuration.defaultWebpagePreferences.preferredContentMode = .mobile
            configuration.allowsInlineMediaPlayback = true
            configuration.ignoresViewportScaleLimits = true
            
            let dark = UIApplication.dark && Defaults.dark
            if dark {
                configuration.userContentController.dark()
            }
            
            self.view = view
            super.init(configuration: configuration)
            scrollView.keyboardDismissMode = .none
            isOpaque = !dark
            
            publisher(for: \.estimatedProgress).sink {
                view.session.progress = $0
            }.store(in: &subs)
            
            publisher(for: \.isLoading).sink {
                view.session.loading = $0
            }.store(in: &subs)
            
            publisher(for: \.title).sink {
                $0.map {
                    Cloud.shared.update(view.id, title: $0)
                }
            }.store(in: &subs)
            
            publisher(for: \.url).sink {
                $0.map {
                    Cloud.shared.update(view.id, url: $0)
                }
            }.store(in: &subs)
            
            publisher(for: \.canGoForward).sink {
                view.session.forwards = $0
            }.store(in: &subs)
            
            view.session.previous.sink { [weak self] in
                if self?.canGoBack == true {
                    self?.goBack()
                } else {
                    view.session.section = .history
                }
            }.store(in: &subs)
            
            view.session.next.sink { [weak self] in
                self?.goForward()
            }.store(in: &subs)
            
            view.session.load.sink { [weak self] in
                self?.load(view.id)
            }.store(in: &subs)
            
            view.session.reload.sink { [weak self] in
                self?.reload()
            }.store(in: &subs)
            
            view.session.stop.sink { [weak self] in
                self?.stopLoading()
            }.store(in: &subs)
            
            view.session.find.sink { [weak self] in
                self?.select(nil)
                self?.find($0) {
                    guard $0.matchFound else { return }
                    self?.evaluateJavaScript("window.getSelection().getRangeAt(0).getBoundingClientRect().top") { offset, _ in
                        guard let offset = offset as? CGFloat, let current = self?.scrollView.contentOffset.y else { return }
                        self?.scrollView.scrollRectToVisible(.init(x: 0, y: offset + current - 200, width: 100, height: 400), animated: true)
                    }
                }
            }.store(in: &subs)
            
            view.session.print.sink { [weak self] in
                UIPrintInteractionController.shared.printFormatter = self?.viewPrintFormatter()
                UIPrintInteractionController.shared.present(animated: true)
            }.store(in: &subs)
            
            view.session.pdf.sink { [weak self] in
                self?.createPDF {
                    guard
                        case let .success(data) = $0,
                        var name = view.session.entry?.url.components(separatedBy: "/").last
                    else { return }
                    if name.isEmpty {
                        name = "Page.pdf"
                    } else if !name.hasSuffix(".pdf") {
                        name = {
                            $0.count > 1 ? $0.dropLast().joined(separator: ".") : $0.first!
                        } (name.components(separatedBy: ".")) + ".pdf"
                    }
                    UIApplication.shared.share(data.temporal(name))
                }
            }.store(in: &subs)
        }
        
        func webView(_: WKWebView, didStartProvisionalNavigation: WKNavigation!) {
            UIApplication.shared.resign()
        }
        
        func webView(_: WKWebView, didFinish: WKNavigation!) {
            view.session.progress = 1
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
            switch Cloud.shared.validate(decidePolicyFor.request.url!, with: protection) {
            case .allow:
                print("allow \(decidePolicyFor.request.url!)")
                preferences.allowsContentJavaScript = javascript
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
    }
}
