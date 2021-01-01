import WebKit
import Combine
import Sleuth

extension Web {
    final class Coordinator: _Web {
        private let view: Web
        
        required init?(coder: NSCoder) { nil }
        init(view: Web) {
            let configuration = WKWebViewConfiguration()
            configuration.dataDetectorTypes = [.link]
            configuration.defaultWebpagePreferences.preferredContentMode = .mobile
            
            let dark = UIApplication.dark && Defaults.dark
            if dark {
                configuration.userContentController.dark()
            }
            
            self.view = view
            super.init(configuration: configuration)
            scrollView.keyboardDismissMode = .onDrag
            isOpaque = !dark
            
            publisher(for: \.estimatedProgress).sink {
                view.session.progress = $0
            }.store(in: &subs)
            
            publisher(for: \.title).sink {
                $0.map {
                    guard !$0.isEmpty else { return }
                    view.session.page?.title = $0
                }
            }.store(in: &subs)
            
            publisher(for: \.url).sink {
                $0.map {
                    view.session.page?.url = $0
                }
            }.store(in: &subs)
            
            publisher(for: \.canGoBack).sink {
                view.session.backwards = $0
            }.store(in: &subs)
            
            publisher(for: \.canGoForward).sink {
                view.session.forwards = $0
            }.store(in: &subs)
            
            view.session.previous.sink { [weak self] in
                self?.goBack()
            }.store(in: &subs)
            
            view.session.next.sink { [weak self] in
                self?.goForward()
            }.store(in: &subs)
            
            view.session.reload.sink { [weak self] in
                self?.reload()
            }.store(in: &subs)
            
            view.session.stop.sink { [weak self] in
                self?.stopLoading()
            }.store(in: &subs)
            
            view.session.browse.sink { [weak self] in
                self?.load(.init(url: $0))
            }.store(in: &subs)
            
            load(.init(url: view.session.page!.url))
        }
        
        func webView(_: WKWebView, didStartProvisionalNavigation: WKNavigation!) {
            view.session.typing = false
            view.session.error = nil
        }
        
        func webView(_: WKWebView, didFinish: WKNavigation!) {
            view.session.progress = 1
        }
        
        final func webView(_: WKWebView, didFailProvisionalNavigation: WKNavigation!, withError: Error) {
            if let error = withError as? URLError {
                switch error.code {
                case .networkConnectionLost,
                     .notConnectedToInternet,
                     .dnsLookupFailed,
                     .resourceUnavailable,
                     .unsupportedURL,
                     .cannotFindHost,
                     .cannotConnectToHost,
                     .timedOut,
                     .secureConnectionFailed,
                     .serverCertificateUntrusted:
                    view.session.error = error.localizedDescription
                default: break
                }
            } else if (withError as NSError).code == 101 {
                view.session.error = withError.localizedDescription
            }
            view.session.progress = 1
        }
        
        final func webView(_: WKWebView, createWebViewWith: WKWebViewConfiguration, for action: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
            if action.targetFrame == nil && (action.navigationType == .other || action.navigationType == .linkActivated) {
                action.request.url.map(view.session.browse.send)
            }
            return nil
        }
        
        final func webView(_: WKWebView, decidePolicyFor: WKNavigationAction, preferences: WKWebpagePreferences, decisionHandler: @escaping (WKNavigationActionPolicy, WKWebpagePreferences) -> Void) {
            var sub: AnyCancellable?
            sub = shield.policy(for: decidePolicyFor.request.url!, shield: trackers).receive(on: DispatchQueue.main).sink { [weak self] in
                sub?.cancel()
                switch $0 {
                case .allow:
                    print("allow \(decidePolicyFor.request.url!)")
                    preferences.allowsContentJavaScript = self?.javascript ?? false
                    decisionHandler(.allow, preferences)
                case .external:
                    print("external \(decidePolicyFor.request.url!)")
                    decisionHandler(.cancel, preferences)
                    UIApplication.shared.open(decidePolicyFor.request.url!)
                case .ignore:
                    decisionHandler(.cancel, preferences)
                case .block(let domain):
                    decisionHandler(.cancel, preferences)
                    self?.view.session.blocked.insert(domain)
                }
            }
        }
    }
}
