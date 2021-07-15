import AppKit
import Combine
import Sleuth

final class Window: NSWindow {
    let session = Session()
    private var subs = Set<AnyCancellable>()
    private let finder = NSTextFinder()
    
    init() {
        super.init(contentRect: .init(x: 0,
                                      y: 0,
                                      width: NSScreen.main!.frame.width * 0.5,
                                      height: NSScreen.main!.frame.height),
                   styleMask: [.closable, .miniaturizable, .resizable, .titled, .fullSizeContentView],
                   backing: .buffered,
                   defer: false)
        minSize = .init(width: 600, height: 200)
        toolbar = .init()
        isReleasedWhenClosed = false
        setFrameAutosaveName("Window")
        tabbingMode = .disallowed
        titlebarAppearsTransparent = true
        
        let content = Content()
        contentView = content
        
        let accessory = NSTitlebarAccessoryViewController()
        accessory.view = Bar(session: session)
        accessory.layoutAttribute = .top
        addTitlebarAccessoryViewController(accessory)
        
        session
            .tabber
            .items
            .combineLatest(session
                            .current
                            .removeDuplicates())
            .map {
                (state: $0[state: $1], id: $1)
            }
            .removeDuplicates {
                $0.state == $1.state && $0.id == $1.id
            }
            .sink { [weak self] in
                switch $0.state {
                case .new:
                    content.display = New(id: $0.id)
                case let .browse(browse):
                    let web = (tabber.items.value[web: $0.id] as? Web) ?? Web(id: $0.id, browse: browse)
                    if tabber.items.value[web: $0.id] == nil {
                        tabber.update($0.id, web: web)
                    }
                    let browser = Browser(web: web)
                    self?.finder.client = web
                    self?.finder.findBarContainer = browser
                    content.display = browser
                    self?.makeFirstResponder(web)
                case let .error(browse, error):
                    self?.finder.client = nil
                    self?.finder.findBarContainer = nil
                    content.display = Error(id: $0.id, browse: browse, error: error)
                    self?.makeFirstResponder(self?.contentView)
                }
            }
            .store(in: &subs)
    }
    
//    override func close() {
//        (tabber.items.value[web: id] as? Web)?.clear()
//        tabber.close(id)
//        super.close()
//    }
    
    override func resignKey() {
        super.resignKey()
        childWindows?.forEach {
                removeChildWindow($0)
                $0.orderOut(nil)
            }
    }
    
    override func performTextFinderAction(_ sender: Any?) {
        (sender as? NSMenuItem)
            .flatMap {
                NSTextFinder.Action(rawValue: $0.tag)
            }
            .map {
                finder.performAction($0)

                switch $0 {
                case .showFindInterface:
                    finder.findBarContainer?.isFindBarVisible = true
                default: break
                }
            }
    }
    
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
