import AppKit

extension Forget.Option {
    final class Destructive: Forget.Option {
        override func update() {
            super.update()
            
            switch state {
            case .pressed:
                layer!.backgroundColor = NSColor.unemphasizedSelectedContentBackgroundColor.cgColor
            case .highlighted:
                layer!.backgroundColor = NSColor.underPageBackgroundColor.cgColor
            default:
                layer!.backgroundColor = NSColor.windowBackgroundColor.cgColor
            }
        }
    }
}
