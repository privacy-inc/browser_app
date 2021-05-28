import AppKit
import Combine
import Sleuth

final class Search: NSView {
    private(set) weak var field: Field!
    private var subs = Set<AnyCancellable>()
    
    required init?(coder: NSCoder) { nil }
    init(id: UUID) {
        super.init(frame: .zero)
        
        let back = Control.Squircle(icon: "chevron.left")
        back
            .click
            .sink {
                
            }
            .store(in: &subs)
        
        let forward = Control.Squircle(icon: "chevron.right")
        forward
            .click
            .sink {
                
            }
            .store(in: &subs)
        
        let refresh = Control.Squircle(icon: "arrow.clockwise")
        refresh
            .click
            .sink {
                
            }
            .store(in: &subs)
        
        let info = Control.Squircle(icon: "info.circle")
        info
            .click
            .sink {
                
            }
            .store(in: &subs)
        
        let bookmark = Control.Squircle(icon: "bookmark")
        bookmark
            .click
            .sink {
                
            }
            .store(in: &subs)
        
        let share = Control.Squircle(icon: "square.and.arrow.up.on.square")
        share
            .click
            .sink {
                
            }
            .store(in: &subs)
        
        let find = Control.Squircle(icon: "doc.text.magnifyingglass")
        find
            .click
            .sink {
                
            }
            .store(in: &subs)
        
        let background = NSView()
        background.translatesAutoresizingMaskIntoConstraints = false
        background.wantsLayer = true
        background.layer!.backgroundColor = NSColor.unemphasizedSelectedContentBackgroundColor.cgColor
        background.layer!.cornerRadius = 4
        addSubview(background)
        
        let field = Field(id: id)
        addSubview(field)
        self.field = field
        
        let google = NSMenuItem(title: "Google", action: #selector(change), keyEquivalent: "")
        google.tag = .init(Engine.google.rawValue)
        google.target = self
        
        let ecosia = NSMenuItem(title: "Ecosia", action: #selector(change), keyEquivalent: "")
        ecosia.tag = .init(Engine.ecosia.rawValue)
        ecosia.target = self
        
        let options = NSMenu()
        options.items = [google, ecosia]
        options.showsStateColumn = true
        
        let engine = Control.Icon(icon: "magnifyingglass")
        engine
            .click
            .map {
                Int(cloud.archive.value.settings.engine.rawValue)
            }
            .sink { [weak self] current in
                [google, ecosia]
                    .forEach {
                        $0.state = $0.tag == current ? .on : .off
                    }
                options.minimumWidth = field.frame.size.width
                options.popUp(positioning: options.item(at: 0), at: .init(x: field.frame.origin.x, y: 0), in: self)
            }
            .store(in: &subs)
        
        let clear = Control.Icon(icon: "xmark.circle.fill")
        clear
            .click
            .sink {
                
            }
            .store(in: &subs)
        
        [back, forward, refresh, info, bookmark, share, find, field, engine, clear]
            .forEach {
                addSubview($0)
                $0.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            }
        
        _ = [back, forward, refresh, info, bookmark, share, find]
            .reduce(self as NSView) {
                if $0 == self {
                    $1.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor, constant: 20).isActive = true
                } else {
                    $1.leftAnchor.constraint(equalTo: $0.rightAnchor, constant: 10).isActive = true
                }
                return $1
            }
        
        [engine, clear]
            .forEach {
                $0.widthAnchor.constraint(equalToConstant: 30).isActive = true
                $0.heightAnchor.constraint(equalToConstant: 26).isActive = true
            }
        
        field.leftAnchor.constraint(equalTo: find.rightAnchor, constant: 12).isActive = true
        field.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: -10).isActive = true
        
        engine.leftAnchor.constraint(equalTo: field.leftAnchor).isActive = true
        clear.rightAnchor.constraint(equalTo: field.rightAnchor).isActive = true
        
        background.topAnchor.constraint(equalTo: field.topAnchor).isActive = true
        background.bottomAnchor.constraint(equalTo: field.bottomAnchor).isActive = true
        background.leftAnchor.constraint(equalTo: field.leftAnchor).isActive = true
        background.rightAnchor.constraint(equalTo: field.rightAnchor).isActive = true
    }
    
    override func mouseUp(with: NSEvent) {
        guard
            with.clickCount >= 2,
            hitTest(with.locationInWindow) != field
        else {
            super.mouseUp(with: with)
            return
        }
        window?.performZoom(nil)
    }
    
    @objc private func change(_ engine: NSMenuItem) {
        cloud.engine(.init(rawValue: .init(engine.tag))!)
    }
}
