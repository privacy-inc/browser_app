import AppKit

final class Scroll: NSScrollView {
    var views: [NSView] { documentView!.subviews }
    
    var top: NSLayoutYAxisAnchor { documentView!.topAnchor }
    var bottom: NSLayoutYAxisAnchor { documentView!.bottomAnchor }
    var left: NSLayoutXAxisAnchor { documentView!.leftAnchor }
    var right: NSLayoutXAxisAnchor { documentView!.rightAnchor }
    var centerX: NSLayoutXAxisAnchor { documentView!.centerXAnchor }
    var centerY: NSLayoutYAxisAnchor { documentView!.centerYAnchor }
    var width: NSLayoutDimension { documentView!.widthAnchor }
    var height: NSLayoutDimension { documentView!.heightAnchor }
    
    required init?(coder: NSCoder) { nil }
    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        documentView = Flip()
        documentView!.translatesAutoresizingMaskIntoConstraints = false
        documentView!.topAnchor.constraint(equalTo: topAnchor).isActive = true
        documentView!.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
    }
    
    func add(_ view: NSView) {
        documentView!.addSubview(view)
    }
}
