import AppKit
import Sleuth

final class Window: NSWindow {
//    private let finder = NSTextFinder()
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
    
    #warning("finder")
    
//    override func performTextFinderAction(_ sender: Any?) {
//        (sender as? NSMenuItem)
//            .flatMap {
//                NSTextFinder.Action(rawValue: $0.tag)
//            }
//            .map {
//                finder.performAction($0)
//
//                switch $0 {
//                case .showFindInterface:
//                    finder.findBarContainer?.isFindBarVisible = true
//                default: break
//                }
//            }
//    }
    
    @objc func location() {
//        search.field.selectText(nil)
    }
}
