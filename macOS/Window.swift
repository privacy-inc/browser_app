import AppKit

final class Window: NSWindow, NSToolbarDelegate {
    init() {
        super.init(contentRect: .init(x: 0, y: 0, width: NSScreen.main!.frame.width / 2, height: NSScreen.main!.frame.height), styleMask:
            [.borderless, .closable, .miniaturizable, .resizable, .titled, .unifiedTitleAndToolbar, .fullSizeContentView],
                   backing: .buffered, defer: false)
        minSize = .init(width: 400, height: 300)
        titlebarAppearsTransparent = true
        titleVisibility = .hidden
        toolbar = .init()
        toolbar!.delegate = self
        toolbar!.showsBaselineSeparator = false
        toolbar!.items = [NSToolbarItem()]
        collectionBehavior = .fullScreenNone
        isReleasedWhenClosed = false
        setFrameAutosaveName("Window")
        
        
        let field = NSSearchField()
        field.translatesAutoresizingMaskIntoConstraints = false
        contentView!.addSubview(field)
        
        field.leftAnchor.constraint(equalTo: contentView!.leftAnchor, constant: 100).isActive = true
        field.topAnchor.constraint(equalTo: contentView!.topAnchor).isActive = true
        field.widthAnchor.constraint(equalToConstant: 200).isActive = true
//        field.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
    
    override func close() {
        super.close()
        NSApp.terminate(nil)
    }
    
//    private func launch() {
//        contentView!.subviews.forEach { $0.removeFromSuperview() }
//
//        let launch = Launch()
//        launch.new.target = self
//        launch.new.action = #selector(game)
//        contentView!.addSubview(launch)
//
//        launch.topAnchor.constraint(equalTo: contentView!.topAnchor).isActive = true
//        launch.bottomAnchor.constraint(equalTo: contentView!.bottomAnchor).isActive = true
//        launch.leftAnchor.constraint(equalTo: contentView!.leftAnchor).isActive = true
//        launch.rightAnchor.constraint(equalTo: contentView!.rightAnchor).isActive = true
//    }
//
//    @objc private func game() {
//        contentView!.subviews.forEach { $0.removeFromSuperview() }
//
//        let game = Game()
//        contentView!.addSubview(game)
//
//        game.topAnchor.constraint(equalTo: contentView!.topAnchor).isActive = true
//        game.bottomAnchor.constraint(equalTo: contentView!.bottomAnchor).isActive = true
//        game.leftAnchor.constraint(equalTo: contentView!.leftAnchor).isActive = true
//        game.rightAnchor.constraint(equalTo: contentView!.rightAnchor).isActive = true
//    }
}
