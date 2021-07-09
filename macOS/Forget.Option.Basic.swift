import AppKit

extension Forget.Option {
    final class Basic: Forget.Option {
        override func update() {
            super.update()
            
            switch state {
            case .pressed:
                layer!.backgroundColor = NSColor.selectedContentBackgroundColor.cgColor
            case .highlighted:
                layer!.backgroundColor = NSColor.windowBackgroundColor.cgColor
            default:
                layer!.backgroundColor = .clear
            }
        }
    }
}
