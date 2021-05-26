import AppKit

final class Progress: NSView {
    let id: UUID
    
    required init?(coder: NSCoder) { nil }
    init(id: UUID) {
        self.id = id
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        
        let border = NSView()
        border.translatesAutoresizingMaskIntoConstraints = false
        border.wantsLayer = true
        border.layer!.backgroundColor = NSColor.separatorColor.cgColor
        addSubview(border)
        
        heightAnchor.constraint(equalToConstant: 6).isActive = true
        
        border.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        border.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        border.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        border.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
}
