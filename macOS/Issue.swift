import AppKit

final class Issue: NSView {
    required init?(coder: NSCoder) { nil }
    init(browser: Browser) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        wantsLayer = true
        layer!.backgroundColor = NSColor.controlBackgroundColor.cgColor
        
        let image = NSImageView(image: NSImage(systemSymbolName: "exclamationmark.triangle.fill", accessibilityDescription: nil)!)
        image.symbolConfiguration = .init(textStyle: .largeTitle, scale: .large)
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentTintColor = .controlAccentColor
        addSubview(image)
        
        let url = Text()
        url.stringValue = browser.page.value?.url.absoluteString ?? ""
        url.font = .systemFont(ofSize: 14, weight: .regular)
        url.alignment = .center
        addSubview(url)
        
        let message = Text()
        message.stringValue = browser.error.value ?? ""
        message.font = .systemFont(ofSize: 14, weight: .light)
        message.textColor = .secondaryLabelColor
        message.alignment = .center
        addSubview(message)
        
        image.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        image.topAnchor.constraint(equalTo: topAnchor, constant: 50).isActive = true
        
        url.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 50).isActive = true
        url.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        url.widthAnchor.constraint(lessThanOrEqualToConstant: 300).isActive = true
        
        message.topAnchor.constraint(equalTo: url.bottomAnchor, constant: 2).isActive = true
        message.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        message.widthAnchor.constraint(lessThanOrEqualToConstant: 300).isActive = true
    }
}
