import AppKit
import Sleuth

final class Window: NSWindow {
    let session: Session
    
    init(tab: Tab) {
        self.session = .init(tab: tab)
        super.init(contentRect: .init(x: 0,
                                      y: 0,
                                      width: NSScreen.main!.frame.width * 0.5,
                                      height: NSScreen.main!.frame.height),
                   styleMask: [.closable, .miniaturizable, .resizable, .titled, .fullSizeContentView],
                   backing: .buffered,
                   defer: false)
        minSize = .init(width: 600, height: 300)
        toolbar = .init()
        isReleasedWhenClosed = false
        setFrameAutosaveName("Window")
        tabbingMode = .disallowed
        titlebarAppearsTransparent = true
        
        let content = Content(session: session)
        contentView = content
        
        let accessory = NSTitlebarAccessoryViewController()
        accessory.view = Bar(session: session)
        accessory.layoutAttribute = .top
        addTitlebarAccessoryViewController(accessory)
    }
    
    @objc func plus() {
        session
            .plus
            .send()
    }
    
    @objc func closeTab() {
        session
            .close
            .send(session
                    .current
                    .value)
    }
    
    @objc func stop() {
        session.stop.send(session.current.value)
    }

    @objc func reload() {
        session.reload.send(session.current.value)
    }

    @objc func actualSize() {
        session.actualSize.send(session.current.value)
    }

    @objc func zoomIn() {
        session.zoomIn.send(session.current.value)
    }

    @objc func zoomOut() {
        session.zoomOut.send(session.current.value)
    }
    
    @objc func tryAgain() {
        switch session
            .tab
            .items
            .value[state: session.current.value] {
        case let .error(browse, error):
            cloud
                .browse(error.url, browse: browse) { [weak self] in
                    guard let id = self?.session.current.value else { return }
                    self?
                        .session
                        .tab
                        .browse(id, browse)
                    self?
                        .session
                        .load
                        .send((id: id, access: $1))
                }
        default: break
        }
    }
    
    @objc func location() {
        session
            .search
            .send(session
                    .current
                    .value)
    }
    
    @objc func nextTab() {
        print("next")
    }
    
    @objc func previousTab() {
        print("prev")
    }
    
    override func performTextFinderAction(_ sender: Any?) {
        (NSApp.keyWindow as? Window)
            .map {
                $0
                    .contentView?
                    .subviews
                    .compactMap {
                        $0 as? Browser
                    }
                    .first
                    .map {
                        $0.performTextFinderAction(sender)
                    }
            }
    }
}
