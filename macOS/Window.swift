import AppKit
import Combine

final class Window: NSWindow {
    private weak var progress: Progress!
    private var subs = Set<AnyCancellable>()
    private let id: UUID
    
    init(id: UUID) {
        self.id = id
        super.init(contentRect: .init(x: 0,
                                      y: 0,
                                      width: NSScreen.main!.frame.width * 0.5,
                                      height: NSScreen.main!.frame.height),
                   styleMask: [.closable, .miniaturizable, .resizable, .titled, .fullSizeContentView],
                   backing: .buffered,
                   defer: false)
        minSize = .init(width: 500, height: 200)
        toolbar = .init()
        titlebarAppearsTransparent = true
        collectionBehavior = .fullScreenNone
        isReleasedWhenClosed = false
        setFrameAutosaveName("Window")
        tab.title = NSLocalizedString("Privacy", comment: "")
        tabbingMode = .preferred
        toggleTabBar(nil)

        let search = Search(id: id)
        let bar = NSTitlebarAccessoryViewController()
        bar.view = search
        bar.layoutAttribute = .top
        addTitlebarAccessoryViewController(bar)
        
        let progress = Progress(id: id)
        contentView!.addSubview(progress)
        self.progress = progress
        
        initialFirstResponder = search.field
        
        progress.bottomAnchor.constraint(equalTo: contentView!.safeAreaLayoutGuide.topAnchor).isActive = true
        progress.leftAnchor.constraint(equalTo: contentView!.leftAnchor, constant: 1).isActive = true
        progress.rightAnchor.constraint(equalTo: contentView!.rightAnchor, constant: -1).isActive = true
        
        tabber
            .items
            .map {
                $0[state: id]
            }
            .removeDuplicates()
            .sink { [weak self] in
                switch $0 {
                case .new:
                    self?.show(New(id: id))
                case let .browse(browse):
                    self?.show(Web(id: id, browse: browse))
                case .error:
                    break
                }
            }
            .store(in: &subs)
    }
    
    override func resignKey() {
        super.resignKey()
        childWindows?.forEach {
                removeChildWindow($0)
                $0.orderOut(nil)
            }
    }
    
    override func becomeMain() {
        super.becomeMain()
        dim(opacity: 1)
    }
    
    override func resignMain() {
        super.resignMain()
        dim(opacity: 0.6)
    }
    
    override func newWindowForTab(_: Any?) {
        NSApp.tab()
    }
    
    private func show(_ view: NSView) {
        contentView!
            .subviews
            .filter {
                $0 != progress
            }
            .forEach {
                $0.removeFromSuperview()
            }
        
        view.wantsLayer = true
        view.layer!.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.layer!.cornerRadius = 9
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView!.addSubview(view)
        
        view.topAnchor.constraint(equalTo: progress.bottomAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: contentView!.bottomAnchor, constant: -1).isActive = true
        view.leftAnchor.constraint(equalTo: contentView!.leftAnchor, constant: 1).isActive = true
        view.rightAnchor.constraint(equalTo: contentView!.rightAnchor, constant: -1).isActive = true
    }
    
    private func dim(opacity: CGFloat) {
        titlebarAccessoryViewControllers.first!.view.alphaValue = opacity
    }
}
