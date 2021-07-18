import AppKit
import Sleuth

final class Window: NSWindow {
//    private let finder = NSTextFinder()
    private let session = Session()
    
    init() {
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
    
    func open(url: URL, change: Bool) {
        #warning("complete")
    }
    
    @objc func plus() {
        session
            .plus
            .send()
    }
    
    
    
    

    
    
    
    
//    override func resignKey() {
//        #warning("investigate if still necessary")
        
//        childWindows?
//            .forEach {
//                removeChildWindow($0)
//                $0.close()
//            }
//        super.resignKey()
//    }
    
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
    
    @objc func shut() {
//        if let tabs = tabbedWindows {
//            tabs.forEach {
//                $0.close()
//            }
//        } else {
//            close()
//        }
    }
}
