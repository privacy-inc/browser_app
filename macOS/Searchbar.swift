import AppKit

final class Searchbar: NSView {
    private(set) weak var field: Field!
    private(set) weak var left: Control.Button!
    private(set) weak var right: Control.Button!
    private(set) weak var detail: Control.Button!
    
    required init?(coder: NSCoder) { nil }
    init() {
        super.init(frame: .zero)
        let background = NSView()
        background.translatesAutoresizingMaskIntoConstraints = false
        background.wantsLayer = true
        background.layer!.backgroundColor = NSColor.windowBackgroundColor.cgColor
        background.layer!.cornerRadius = 6
        addSubview(background)
        
        let field = Field()
        addSubview(field)
        self.field = field
        
        let left = Control.Button("chevron.left")
        addSubview(left)
        self.left = left
        
        let right = Control.Button("chevron.right")
        addSubview(right)
        self.right = right
        
        let detail = Control.Button("line.horizontal.3")
        addSubview(detail)
        self.detail = detail
        
        background.topAnchor.constraint(equalTo: field.topAnchor).isActive = true
        background.bottomAnchor.constraint(equalTo: field.bottomAnchor).isActive = true
        background.leftAnchor.constraint(equalTo: field.leftAnchor).isActive = true
        background.rightAnchor.constraint(equalTo: field.rightAnchor).isActive = true
        
        field.leftAnchor.constraint(equalTo: right.rightAnchor, constant: 10).isActive = true
        field.rightAnchor.constraint(equalTo: detail.leftAnchor, constant: -10).isActive = true
        field.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        left.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        left.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
        
        right.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        right.leftAnchor.constraint(equalTo: left.rightAnchor).isActive = true
        
        detail.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        detail.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
    }
}
