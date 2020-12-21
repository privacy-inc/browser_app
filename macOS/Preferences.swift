import AppKit
import Sleuth
import Combine

final class Preferences: NSWindow {
    private var subs = Set<AnyCancellable>()
    
    init() {
        super.init(contentRect: .init(x: 0, y: 0, width: 460, height: 600),
                   styleMask: [.closable, .titled, .fullSizeContentView], backing: .buffered, defer: false)
        toolbar = .init()
        title = NSLocalizedString("Preferences", comment: "")
        titlebarAppearsTransparent = true
        collectionBehavior = .fullScreenNone
        isReleasedWhenClosed = false
        center()
        
        let titleEngine = Text()
        titleEngine.stringValue = NSLocalizedString("Search engine", comment: "")
        titleEngine.textColor = .secondaryLabelColor
        titleEngine.font = .systemFont(ofSize: 12, weight: .regular)
        contentView!.addSubview(titleEngine)
        
        let segmented = Segmented(items: ["Google", "Ecosia"])
        segmented.selected.value = Defaults.engine == .google ? 0 : 1
        segmented.selected.dropFirst().sink {
            Defaults.engine = $0 == 0 ? .google : .ecosia
        }.store(in: &subs)
        contentView!.addSubview(segmented)
        
        let titleOptions = Text()
        titleOptions.stringValue = NSLocalizedString("Options", comment: "")
        titleOptions.textColor = .secondaryLabelColor
        titleOptions.font = .systemFont(ofSize: 12, weight: .regular)
        contentView!.addSubview(titleOptions)
        
        let dark = Toggle(title: NSLocalizedString("Force dark mode", comment: ""))
        dark.value.value = Defaults.dark
        dark.value.dropFirst().sink {
            Defaults.dark = $0
        }.store(in: &subs)
        contentView!.addSubview(dark)
        
        titleEngine.topAnchor.constraint(equalTo: contentView!.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        titleEngine.leftAnchor.constraint(equalTo: contentView!.safeAreaLayoutGuide.leftAnchor, constant: 60).isActive = true
        
        segmented.topAnchor.constraint(equalTo: titleEngine.bottomAnchor, constant: 12).isActive = true
        segmented.leftAnchor.constraint(equalTo: contentView!.safeAreaLayoutGuide.leftAnchor, constant: 60).isActive = true
        segmented.rightAnchor.constraint(equalTo: contentView!.safeAreaLayoutGuide.rightAnchor, constant: -60).isActive = true
        
        titleOptions.topAnchor.constraint(equalTo: segmented.bottomAnchor, constant: 40).isActive = true
        titleOptions.leftAnchor.constraint(equalTo: contentView!.safeAreaLayoutGuide.leftAnchor, constant: 60).isActive = true
        
        dark.topAnchor.constraint(equalTo: titleOptions.bottomAnchor, constant: 12).isActive = true
        dark.leftAnchor.constraint(equalTo: contentView!.safeAreaLayoutGuide.leftAnchor, constant: 60).isActive = true
        dark.rightAnchor.constraint(equalTo: contentView!.safeAreaLayoutGuide.rightAnchor, constant: -60).isActive = true
    }
}
