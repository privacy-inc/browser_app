import WebKit

extension UIApplication {
    static let status = shared
        .connectedScenes
        .compactMap {
            $0 as? UIWindowScene
        }
        .compactMap {
            $0
                .statusBarManager
        }
        .map {
            $0
                .statusBarFrame
        }
        .map(\.height)
        .max() ?? 0
    
    static let tab = shared
        .connectedScenes
        .compactMap {
            $0 as? UIWindowScene
        }
        .compactMap {
            $0.ins
        }
    
    static let dark = shared.windows.map(\.rootViewController?.traitCollection.userInterfaceStyle).first == .dark
    
    var root: UIViewController? {
        guard var root = windows.first?.rootViewController else { return nil }
        while let presented = root.presentedViewController {
            root = presented
        }
        return root
    }
    
    func resign() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    func settings() {
        open(URL(string: Self.openSettingsURLString)!)
    }
    
    func share(_ any: Any) {
        let root = self.root
        let controller = UIActivityViewController(activityItems: [any], applicationActivities: nil)
        controller.popoverPresentationController?.sourceView = root?.view
        root?.present(controller, animated: true)
    }
}
