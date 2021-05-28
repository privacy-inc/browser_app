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
        tabbingMode = .preferred
        tab.title = NSLocalizedString("Privacy", comment: "")
        
        let _search = Search(id: id)
        let search = NSTitlebarAccessoryViewController()
        search.view = _search
        search.layoutAttribute = .top
        addTitlebarAccessoryViewController(search)

        let results = NSTitlebarAccessoryViewController()
        results.view = Search.Results(id: id)
        results.layoutAttribute = .bottom
        addTitlebarAccessoryViewController(results)
        
        let progress = Progress(id: id)
        contentView!.addSubview(progress)
        self.progress = progress
        
        initialFirstResponder = _search.field
        
        progress.bottomAnchor.constraint(equalTo: contentView!.safeAreaLayoutGuide.topAnchor).isActive = true
        progress.leftAnchor.constraint(equalTo: contentView!.leftAnchor, constant: 1).isActive = true
        progress.rightAnchor.constraint(equalTo: contentView!.rightAnchor, constant: -1).isActive = true
        
        tabber
            .items
            .map {
                $0.state(id)
            }
            .removeDuplicates()
            .sink { [weak self] in
                switch $0 {
                case .new:
                    self?.show(New(id: id))
                case .browse:
                    self?.show(NSView())
                case .error:
                    break
                }
            }
            .store(in: &subs)
    }
    
    override func becomeMain() {
        super.becomeMain()
        dim(1)
    }
    
    override func resignMain() {
        super.resignMain()
        dim(0.3)
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
    
    private func dim(_ opacity: CGFloat) {
        (contentView!.subviews + [titlebarAccessoryViewControllers.first!.view]).forEach {
            $0.alphaValue = opacity
        }
    }
}
