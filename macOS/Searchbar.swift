import AppKit

final class Searchbar: NSView {
    private weak var field: NSSearchField!
    
    required init?(coder: NSCoder) { nil }
    init() {
        super.init(frame: .zero)
        let field = NSSearchField()
        field.translatesAutoresizingMaskIntoConstraints = false
        addSubview(field)
        self.field = field
        
        field.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
        field.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true
        field.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
}
