import WebKit
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
            super.init(browser: view.session.browser, configuration: configuration)
            scrollView.keyboardDismissMode = .onDrag
            isOpaque = !dark
            
            view.session.browser.browse.sink { [weak self] in
                self?.load(.init(url: $0))
            }.store(in: &subs)
            
            load(.init(url: view.session.browser.page.value!.url))
        }
    }
}
