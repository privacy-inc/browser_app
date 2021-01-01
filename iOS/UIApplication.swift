import WebKit

extension UIApplication {
    static let dark = shared.windows.map(\.rootViewController?.traitCollection.userInterfaceStyle).first == .dark
    
    func resign() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    func share(_ any: Any) {
        let controller = UIActivityViewController(activityItems: [any], applicationActivities: nil)
        controller.popoverPresentationController?.sourceView = windows.first?.rootViewController?.presentedViewController?.view
        windows.first?.rootViewController?.presentedViewController?.present(controller, animated: true)
    }
    
    func forget() {
        HTTPCookieStorage.shared.removeCookies(since: .distantPast)
        [WKWebsiteDataStore.default(), WKWebsiteDataStore.nonPersistent()].forEach {
            $0.fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) {
                $0.forEach {
                    WKWebsiteDataStore.default().removeData(ofTypes: $0.dataTypes, for: [$0]) { }
                }
            }
            $0.removeData(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes(), modifiedSince: .distantPast) { }
        }
    }
}
