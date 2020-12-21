import AppKit
import Combine

extension Preferences {
    final class Toggle: NSView {
        let value = CurrentValueSubject<Bool, Never>(false)
        private var sub: AnyCancellable?
        
        required init?(coder: NSCoder) { nil }
        init(title: String) {
            super.init(frame: .zero)
            translatesAutoresizingMaskIntoConstraints = false
            wantsLayer = true
            layer!.backgroundColor = NSColor.labelColor.withAlphaComponent(0.05).cgColor
            layer!.cornerRadius = 8
            
            let text = Text()
            text.stringValue = title
            text.font = .systemFont(ofSize: 14, weight: .regular)
            addSubview(text)
            
            let toggle = NSSwitch()
            toggle.target = self
            toggle.action = #selector(change)
            toggle.translatesAutoresizingMaskIntoConstraints = false
            addSubview(toggle)
            
            heightAnchor.constraint(equalToConstant: 40).isActive = true
            
            text.leftAnchor.constraint(equalTo: leftAnchor, constant: 12).isActive = true
            text.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            
            toggle.rightAnchor.constraint(equalTo: rightAnchor, constant: -12).isActive = true
            toggle.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            
            sub = value.sink {
                toggle.state = $0 ? .on : .off
            }
        }
        
        @objc private func change(_ toggle: NSSwitch) {
            value.value = toggle.state == .on
        }
    }
}
