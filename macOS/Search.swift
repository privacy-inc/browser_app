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
                session.back.send(id)
            }
            .store(in: &subs)
        
        let forward = Control.Squircle(icon: "chevron.right")
        forward
            .click
            .sink {
                session.forward.send(id)
            }
            .store(in: &subs)
        
        let info = Control.Squircle(icon: "info.circle")
        info
            .click
            .sink {
                Info(id: id)
                    .show(relativeTo: info.bounds, of: info, preferredEdge: .minY)
            }
            .store(in: &subs)
        
        let bookmark = Control.Squircle(icon: "bookmark")
        bookmark
            .click
            .sink {
                tabber
                    .items
                    .value[state: id]
                    .browse
                    .map(cloud.bookmark)
                Toast.show(message: .init(title: "Bookmark added", icon: "bookmark"))
            }
            .store(in: &subs)
        
        let share = Control.Squircle(icon: "square.and.arrow.up")
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
        
        let bar = Bar(id: id)
        addSubview(bar)
        
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
                options.popUp(positioning: nil, at: .init(x: field.frame.origin.x, y: 0), in: self)
            }
            .store(in: &subs)
        
        let reload = Control.Icon(icon: "arrow.clockwise")
        reload
            .click
            .sink {
                session.reload.send(id)
            }
            .store(in: &subs)
        
        let stop = Control.Icon(icon: "xmark")
        stop
            .click
            .sink {
                session.stop.send(id)
            }
            .store(in: &subs)
        
        tabber
            .items
            .map {
                $0[state: id].isBrowse
            }
            .removeDuplicates()
            .sink { isBrowse in
                [info, bookmark, share, find]
                    .forEach {
                        $0.state = isBrowse ? .on : .off
                    }
            }
            .store(in: &subs)
        
        tabber
            .items
            .map {
                $0[state: id].isBrowse && $0[back: id]
            }
            .removeDuplicates()
            .sink {
                back.state = $0 ? .on : .off
            }
            .store(in: &subs)
        
        tabber
            .items
            .map {
                $0[state: id].isBrowse && $0[forward: id]
            }
            .removeDuplicates()
            .sink {
                forward.state = $0 ? .on : .off
            }
            .store(in: &subs)
        
        tabber
            .items
            .map {
                (isBrowse: $0[state: id].isBrowse, loading: $0[loading: id])
            }
            .removeDuplicates {
                $0.isBrowse == $1.isBrowse
                    && $0.loading == $1.loading
            }
            .sink {
                reload.state = $0.isBrowse && !$0.loading ? .on : .hidden
                stop.state = $0.isBrowse && $0.loading ? .on : .hidden
            }
            .store(in: &subs)
        
        [back, forward, info, bookmark, share, find, field, engine, reload, stop]
            .forEach {
                addSubview($0)
                $0.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            }
        
        _ = [back, forward, info, bookmark, share, find]
            .reduce(self as NSView) {
                if $0 == self {
                    $1.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor, constant: 8).isActive = true
                } else {
                    $1.leftAnchor.constraint(equalTo: $0.rightAnchor, constant: 10).isActive = true
                }
                return $1
            }
        
        [engine, reload, stop]
            .forEach {
                $0.widthAnchor.constraint(equalToConstant: 30).isActive = true
                $0.heightAnchor.constraint(equalToConstant: 26).isActive = true
            }
        
        field.leftAnchor.constraint(equalTo: find.rightAnchor, constant: 12).isActive = true
        field.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: -10).isActive = true
        
        engine.leftAnchor.constraint(equalTo: field.leftAnchor).isActive = true
        reload.rightAnchor.constraint(equalTo: field.rightAnchor).isActive = true
        stop.rightAnchor.constraint(equalTo: field.rightAnchor).isActive = true
        
        bar.topAnchor.constraint(equalTo: field.topAnchor).isActive = true
        bar.bottomAnchor.constraint(equalTo: field.bottomAnchor, constant: 1).isActive = true
        bar.leftAnchor.constraint(equalTo: field.leftAnchor).isActive = true
        bar.rightAnchor.constraint(equalTo: field.rightAnchor).isActive = true
    }
    
    override func mouseUp(with: NSEvent) {
        guard
            with.clickCount == 2,
            !field.frame.contains(convert(with.locationInWindow, from: nil))
        else { return }
        window?.performZoom(nil)
    }
    
    @objc private func change(_ engine: NSMenuItem) {
        cloud.engine(.init(rawValue: .init(engine.tag))!)
    }
}
