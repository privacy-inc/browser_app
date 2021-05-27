import AppKit
import Combine

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
        
        [back, forward, refresh, info, bookmark, share, find, field]
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
        
        field.leftAnchor.constraint(equalTo: find.rightAnchor, constant: 20).isActive = true
        field.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: -10).isActive = true
        
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
}
