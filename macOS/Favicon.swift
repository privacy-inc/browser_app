import AppKit

final class Favicon: NSImageView {
    required init?(coder: NSCoder) { nil }
    init(id: UUID) {
        super.init(frame: .zero)
        image = NSImage(named: "favicon")
        translatesAutoresizingMaskIntoConstraints = false
        imageScaling = .scaleProportionallyDown
        
        widthAnchor.constraint(equalToConstant: 18).isActive = true
        heightAnchor.constraint(equalTo: widthAnchor).isActive = true
    }
    
    override func hitTest(_: NSPoint) -> NSView? {
        nil
    }
}
