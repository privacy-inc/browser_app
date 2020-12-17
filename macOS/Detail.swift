import AppKit
import Sleuth

final class Detail: NSPopover {
    required init?(coder: NSCoder) { nil }
    init(browser: Browser) {
        super.init()
        behavior = .transient
        contentSize = .init(width: 440, height: 260)
        contentViewController = .init()
        contentViewController!.view = .init()
//
//        let title = Label(.systemFont(ofSize: 16, weight: .bold))
//        title.stringValue = "Resolution"
//        contentViewController!.view.addSubview(title)
//
//        let segmented = Segmented(items: sizes.map { "\(Int($0.width))×\(Int($0.height))" })
//        segmented.selected.value = sizes.count / 2
//        contentViewController!.view.addSubview(segmented)
//        self.segmented = segmented
//
//        let export = Control.Title(text: "Export", background: .systemPink, foreground: .white)
//        export.target = self
//        export.action = #selector(save)
//        contentViewController!.view.addSubview(export)
//
//        let cancel = Control.Title(text: "Cancel", background: .clear, foreground: .labelColor)
//        cancel.target = self
//        cancel.action = #selector(close)
//        contentViewController!.view.addSubview(cancel)
//
//        title.leftAnchor.constraint(equalTo: segmented.leftAnchor).isActive = true
//        title.bottomAnchor.constraint(equalTo: segmented.topAnchor, constant: -12).isActive = true
//
//        segmented.topAnchor.constraint(equalTo: contentViewController!.view.topAnchor, constant: 80).isActive = true
//        segmented.centerXAnchor.constraint(equalTo: contentViewController!.view.centerXAnchor).isActive = true
//        segmented.widthAnchor.constraint(equalToConstant: 380).isActive = true
//
//        export.topAnchor.constraint(equalTo: segmented.bottomAnchor, constant: 40).isActive = true
//        export.centerXAnchor.constraint(equalTo: contentViewController!.view.centerXAnchor).isActive = true
//
//        cancel.topAnchor.constraint(equalTo: export.bottomAnchor, constant: 10).isActive = true
//        cancel.centerXAnchor.constraint(equalTo: contentViewController!.view.centerXAnchor).isActive = true
    }
}
