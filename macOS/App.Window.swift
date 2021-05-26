import Foundation

extension App {
    func window(_ id: UUID) {
        Window(id: id).makeKeyAndOrderFront(nil)
    }
    
    func open(tab url: URL) {
//        guard let key = keyWindow as? Window,
//              key.browser.entry.value == nil
//        else {
//            if let empty = windows
//                .compactMap({ $0 as? Window })
//                .first(where: { $0.browser.entry.value == nil }) {
//
//                Cloud.shared.navigate(url) {
//                    empty.browser.entry.value = $0
//                }
//            } else if let window = windows.compactMap({ $0 as? Window }).first {
//                window.newTab(url)
//            } else {
//                window(url)
//            }
//            return
//        }
//
//        Cloud.shared.navigate(url) {
//            key.browser.entry.value = $0
//        }
    }
}
