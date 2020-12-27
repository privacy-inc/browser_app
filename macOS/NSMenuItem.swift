import AppKit

extension NSMenuItem {
    func synth() {
        (representedObject as? NSMenuItem).map {
            guard let action = $0.action else { return }
            NSApp.sendAction(action, to: $0.target, from: $0)
        }
    }
}
