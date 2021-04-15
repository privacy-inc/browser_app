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
                    view.session.page?.title = $0.trimmingCharacters(in: .whitespacesAndNewlines)
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
            
            view.session.unerror.sink { [weak self] in
                view.session.error = nil
                if let url = self?.url {
                    view.session.page?.url = url
                    self?.title.map {
                        view.session.page?.title = $0
                    }
                } else {
                    view.session.page = nil
                }
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
                    if case .success(let data) = $0 {
                        guard var name = self?.view.session.page?.url.lastPathComponent.replacingOccurrences(of: "/", with: "") else { return }
                        if name.isEmpty {
                            name = "Page.pdf"
                        } else if !name.hasSuffix(".pdf") {
                            name = {
                                $0.count > 1 ? $0.dropLast().joined(separator: ".") : $0.first!
                            } (name.components(separatedBy: ".")) + ".pdf"
                        }
                        UIApplication.shared.share(data.temporal(name))
                    }
                }
            }.store(in: &subs)
            
            load(.init(url: view.session.page!.url))
        }
        
        func webView(_: WKWebView, didStartProvisionalNavigation: WKNavigation!) {
            UIApplication.shared.resign()
            view.session.error = nil
        }
        
        func webView(_: WKWebView, didFinish: WKNavigation!) {
            view.session.progress = 1
        }
        
        func webView(_: WKWebView, didFailProvisionalNavigation: WKNavigation!, withError: Error) {
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
                    error.failingURL.map {
                        view.session.page?.url = $0
                    }
                    view.session.error = error.localizedDescription
                    view.session.page?.title = error.localizedDescription
                default: break
                }
            } else if (withError as NSError).code == 101 {
                view.session.error = withError.localizedDescription
                view.session.page?.title = withError.localizedDescription
            }
            view.session.progress = 1
        }
        
        func webView(_: WKWebView, createWebViewWith: WKWebViewConfiguration, for action: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
            if (action.targetFrame == nil && action.navigationType == .other) || action.navigationType == .linkActivated {
                action.request.url.map(view.session.browse.send)
            }
            return nil
        }
        
        func webView(_: WKWebView, decidePolicyFor: WKNavigationAction, preferences: WKWebpagePreferences, decisionHandler: @escaping (WKNavigationActionPolicy, WKWebpagePreferences) -> Void) {
            switch protection.policy(for: decidePolicyFor.request.url!) {
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
            case .block(let domain):
                decisionHandler(.cancel, preferences)
                Share.blocked.append(domain)
                view.session.update.send()
            }
        }
    }
}
