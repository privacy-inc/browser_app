import AppKit

extension Settings.Option {
    final class Destructive: Settings.Option {
        override func update() {
            super.update()
            
            switch state {
            case .pressed:
                layer!.backgroundColor = NSColor.underPageBackgroundColor.cgColor
            case .highlighted:
                layer!.backgroundColor = NSColor.windowBackgroundColor.cgColor
            default:
                layer!.backgroundColor = NSColor.unemphasizedSelectedContentBackgroundColor.cgColor
            }
        }
    }
}
