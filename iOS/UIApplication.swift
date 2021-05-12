import WebKit

extension UIApplication {
    static let dark = shared.windows.map(\.rootViewController?.traitCollection.userInterfaceStyle).first == .dark
    
    func resign() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    func dismiss() {
        UIApplication.shared.windows.forEach {
            $0.rootViewController?.dismiss(animated: true)
        }
    }
}
