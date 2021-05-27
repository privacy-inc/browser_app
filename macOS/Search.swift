import AppKit
import Combine

final class Search: NSView {
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
        
        [back, forward, refresh, info, bookmark, share, find]
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
    }
}
