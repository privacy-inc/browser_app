import AppKit
import Combine

final class Searchbar: NSView {
    private var subs = Set<AnyCancellable>()
    
    required init?(coder: NSCoder) { nil }
    init(browser: Browser) {
        super.init(frame: .zero)
        let background = NSView()
        background.translatesAutoresizingMaskIntoConstraints = false
        background.wantsLayer = true
        background.layer!.backgroundColor = NSColor.labelColor.withAlphaComponent(0.05).cgColor
        background.layer!.cornerRadius = 6
        addSubview(background)
        
        let field = Field(browser: browser)
        addSubview(field)
        
        let left = Control.Button("chevron.left")
        let right = Control.Button("chevron.right")
        let detail = Control.Button("line.horizontal.3")
        
        let lupe = Control.Button("magnifyingglass")
        let clockwise = Control.Button("arrow.clockwise")
        
        let engine = NSMenu()
        let google = NSMenuItem(title: "Google", action: #selector(change), keyEquivalent: "")
        google.target = self
        
        let ecosia = NSMenuItem(title: "Ecosia", action: #selector(change), keyEquivalent: "")
        ecosia.target = self
        engine.items = [google, ecosia]
        engine.showsStateColumn = true
        
        [left, right, detail].forEach {
            $0.icon.symbolConfiguration = .init(pointSize: 16, weight: .bold)
            $0.style = .blue
            addSubview($0)
            $0.widthAnchor.constraint(equalToConstant: 22).isActive = true
            $0.heightAnchor.constraint(equalTo: $0.widthAnchor).isActive = true
            $0.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        }
        
        [lupe, clockwise].forEach {
            addSubview($0)
            $0.centerYAnchor.constraint(equalTo: field.centerYAnchor).isActive = true
            $0.widthAnchor.constraint(equalToConstant: 35).isActive = true
            $0.heightAnchor.constraint(equalTo: lupe.widthAnchor).isActive = true
        }
        
        background.topAnchor.constraint(equalTo: field.topAnchor).isActive = true
        background.bottomAnchor.constraint(equalTo: field.bottomAnchor).isActive = true
        background.leftAnchor.constraint(equalTo: field.leftAnchor).isActive = true
        background.rightAnchor.constraint(equalTo: field.rightAnchor).isActive = true
        
        field.leftAnchor.constraint(equalTo: right.rightAnchor, constant: 18).isActive = true
        field.rightAnchor.constraint(equalTo: detail.leftAnchor, constant: -18).isActive = true
        field.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        left.leftAnchor.constraint(equalTo: leftAnchor, constant: 18).isActive = true
        right.leftAnchor.constraint(equalTo: left.rightAnchor, constant: 14).isActive = true
        detail.rightAnchor.constraint(equalTo: rightAnchor, constant: -14).isActive = true
        
        lupe.leftAnchor.constraint(equalTo: field.leftAnchor).isActive = true
        clockwise.rightAnchor.constraint(equalTo: field.rightAnchor).isActive = true
        
        lupe.click.sink {
            engine.minimumWidth = field.frame.size.width
            engine.popUp(positioning: engine.item(at: 0), at: .init(x: field.frame.origin.x, y: 0), in: self)
        }.store(in: &subs)
    }
    
    @objc private func change(_ engine: NSMenuItem) {
        
    }
}
