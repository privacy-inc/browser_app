import AppKit

extension Settings.Option {
    class Basic: Settings.Option {
        override func update() {
            super.update()
            
            switch state {
            case .pressed:
                layer!.backgroundColor = NSColor.unemphasizedSelectedContentBackgroundColor.cgColor
            case .highlighted:
                layer!.backgroundColor = NSColor.windowBackgroundColor.cgColor
            default:
                layer!.backgroundColor = .clear
            }
        }
    }
}
