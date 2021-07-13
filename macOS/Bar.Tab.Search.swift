import AppKit
import Combine

extension Bar.Tab {
    final class Search: NSView {
        private var subs = Set<AnyCancellable>()
        
        required init?(coder: NSCoder) { nil }
        init(id: UUID) {
            super.init(frame: .zero)
            translatesAutoresizingMaskIntoConstraints = false
            
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
            
            let background = Background(id: id)
            
            [back, background, forward]
                .forEach {
                    addSubview($0)
                    $0.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
                }
            
            let leftAnchor = self.leftAnchor
            var left = background.leftAnchor.constraint(equalTo: leftAnchor, constant: 5)
            var right = rightAnchor.constraint(equalTo: background.rightAnchor, constant: 5)
            left.isActive = true
            right.isActive = true
            
            tabber
                .items
                .map {
                    $0[state: id].isBrowse && $0[back: id]
                }
                .removeDuplicates()
                .sink {
                    back.state = $0 ? .on : .off
                    back.isHidden = !$0
                    left.isActive = false
                    left = $0
                        ? background.leftAnchor.constraint(equalTo: back.rightAnchor, constant: 5)
                        : background.leftAnchor.constraint(equalTo: leftAnchor, constant: 5)
                    left.isActive = true
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
                    forward.isHidden = !$0
                }
                .store(in: &subs)
            
            
            
            rightAnchor.constraint(equalTo: forward.rightAnchor, constant: 5).isActive = true

            background.topAnchor.constraint(equalTo: topAnchor).isActive = true
            background.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true

            back.leftAnchor.constraint(equalTo: leftAnchor, constant: 5).isActive = true
//            background.leftAnchor.constraint(equalTo: back.rightAnchor, constant: 5).isActive = true
//            forward.leftAnchor.constraint(equalTo: background.rightAnchor, constant: 5).isActive = true
        }
    }
}
