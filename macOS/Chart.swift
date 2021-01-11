import AppKit
import Sleuth

final class Chart: NSView {
    required init?(coder: NSCoder) { nil }
    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        wantsLayer = true
        layer!.frame.size = .init(width: 340, height: 200)
        layer!.addSublayer(Content(frame: .init(x: 0, y: 30, width: layer!.frame.width, height: layer!.frame.height - 60)))
        layer!.masksToBounds = false
        
        let chart = Share.chart
        
        let title = Text()
        title.stringValue = NSLocalizedString("Usage", comment: "")
        title.font = .systemFont(ofSize: 14, weight: .medium)
        addSubview(title)
        
        let since = Text()
        since.stringValue = chart.isEmpty ? "" : RelativeDateTimeFormatter().localizedString(for: chart.first!, relativeTo: .init())
        since.font = .systemFont(ofSize: 12, weight: .regular)
        since.textColor = .secondaryLabelColor
        addSubview(since)
        
        let now = Text()
        now.stringValue = NSLocalizedString("Now", comment: "")
        now.font = .systemFont(ofSize: 12, weight: .regular)
        now.textColor = .secondaryLabelColor
        addSubview(now)
        
        widthAnchor.constraint(equalToConstant: layer!.frame.width).isActive = true
        heightAnchor.constraint(equalToConstant: layer!.frame.height).isActive = true
        
        title.topAnchor.constraint(equalTo: topAnchor).isActive = true
        title.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        
        since.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        since.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        
        now.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        now.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
    }
}
