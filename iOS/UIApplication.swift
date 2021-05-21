import WebKit

extension UIApplication {
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
    
    func share(_ any: Any) {
        let root = self.root
        let controller = UIActivityViewController(activityItems: [any], applicationActivities: nil)
        controller.popoverPresentationController?.sourceView = root?.view
        root?.present(controller, animated: true)
    }
}
