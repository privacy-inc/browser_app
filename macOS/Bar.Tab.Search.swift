import AppKit
import Combine

extension Bar.Tab {
    final class Search: NSView {
        private var subs = Set<AnyCancellable>()
        
        required init?(coder: NSCoder) { nil }
        init(id: UUID, icon: Icon) {
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
            addSubview(background)
            
            let field = Privacy.Search.Field(id: id)
            
            [back, icon, field, forward]
                .forEach {
                    addSubview($0)
                    $0.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
                }
            
            let backOff = background.leftAnchor.constraint(equalTo: leftAnchor, constant: 5)
            let backOn = background.leftAnchor.constraint(equalTo: back.rightAnchor, constant: 5)
            let forwardOff = rightAnchor.constraint(equalTo: background.rightAnchor, constant: 5)
            let forwardOn = rightAnchor.constraint(equalTo: forward.rightAnchor, constant: 5)
            
            tabber
                .items
                .map {
                    $0[state: id].isBrowse && $0[back: id]
                }
                .removeDuplicates()
                .sink { [weak self] in
                    back.state = $0 ? .on : .off
                    back.isHidden = !$0
                    if $0 {
                        backOff.isActive = false
                        backOn.isActive = true
                    } else {
                        backOn.isActive = false
                        backOff.isActive = true
                    }
                    
                    self?.animate()
                }
                .store(in: &subs)
            
            tabber
                .items
                .map {
                    $0[state: id].isBrowse && $0[forward: id]
                }
                .removeDuplicates()
                .sink { [weak self] in
                    forward.state = $0 ? .on : .off
                    forward.isHidden = !$0
                    
                    if $0 {
                        forwardOff.isActive = false
                        forwardOn.isActive = true
                    } else {
                        forwardOn.isActive = false
                        forwardOff.isActive = true
                    }
                    
                    self?.animate()
                }
                .store(in: &subs)
            
            widthAnchor.constraint(equalToConstant: 340).isActive = true

            background.topAnchor.constraint(equalTo: field.topAnchor).isActive = true
            background.bottomAnchor.constraint(equalTo: field.bottomAnchor, constant: 1).isActive = true

            icon.leftAnchor.constraint(equalTo: background.leftAnchor, constant: 5).isActive = true
            
            field.leftAnchor.constraint(equalTo: background.leftAnchor, constant: 20).isActive = true
            field.rightAnchor.constraint(equalTo: background.rightAnchor, constant: -20).isActive = true
            
            back.leftAnchor.constraint(equalTo: leftAnchor, constant: 5).isActive = true
            forward.leftAnchor.constraint(equalTo: background.rightAnchor, constant: 5).isActive = true
        }
        
        private func animate() {
            NSAnimationContext.runAnimationGroup {
                $0.duration = 0.3
                $0.allowsImplicitAnimation = true
                layoutSubtreeIfNeeded()
            }
        }
    }
}
