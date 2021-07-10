import AppKit

extension Store {
    final class Loading: NSVisualEffectView {
        required init?(coder: NSCoder) { nil }
        init() {
            super.init(frame: .zero)
            
            let icon = Image(icon: "hourglass.bottomhalf.fill")
            icon.symbolConfiguration = .init(textStyle: .largeTitle)
            icon.contentTintColor = .tertiaryLabelColor
            addSubview(icon)
            
            icon.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor).isActive = true
            icon.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        }
    }
}
