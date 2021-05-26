import AppKit

final class New: NSView {
    let id: UUID
    
    required init?(coder: NSCoder) { nil }
    init(id: UUID) {
        self.id = id
        super.init(frame: .zero)
        wantsLayer = true
        layer!.backgroundColor = NSColor.controlBackgroundColor.cgColor
    }
}
