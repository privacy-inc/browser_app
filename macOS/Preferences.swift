import AppKit
import Sleuth
import Combine

final class Preferences: NSWindow {
    private var subs = Set<AnyCancellable>()
    
    init() {
        super.init(contentRect: .init(x: 0, y: 0, width: 460, height: 640),
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
        
        let safe = Toggle(title: NSLocalizedString("Safe browsing", comment: ""))
        safe.value.value = Defaults.secure
        safe.value.dropFirst().sink {
            Defaults.secure = $0
        }.store(in: &subs)
        contentView!.addSubview(safe)
        
        let trackers = Toggle(title: NSLocalizedString("Block trackers", comment: ""))
        trackers.value.value = Defaults.trackers
        trackers.value.dropFirst().sink {
            Defaults.trackers = $0
        }.store(in: &subs)
        contentView!.addSubview(trackers)
        
        let cookies = Toggle(title: NSLocalizedString("Block cookies", comment: ""))
        cookies.value.value = Defaults.cookies
        cookies.value.dropFirst().sink {
            Defaults.cookies = $0
        }.store(in: &subs)
        contentView!.addSubview(cookies)
        
        let popups = Toggle(title: NSLocalizedString("Block pop-ups", comment: ""))
        popups.value.value = Defaults.popups
        popups.value.dropFirst().sink {
            Defaults.popups = $0
        }.store(in: &subs)
        contentView!.addSubview(popups)
        
        let javascript = Toggle(title: NSLocalizedString("Allow JavaScript", comment: ""))
        javascript.value.value = Defaults.javascript
        javascript.value.dropFirst().sink {
            Defaults.javascript = $0
        }.store(in: &subs)
        contentView!.addSubview(javascript)
        
        let ads = Toggle(title: NSLocalizedString("Remove ads", comment: ""))
        ads.value.value = Defaults.ads
        ads.value.dropFirst().sink {
            Defaults.ads = $0
        }.store(in: &subs)
        contentView!.addSubview(ads)
        
        let makeDefault = Button(title: NSLocalizedString("Make default browser", comment: ""))
        makeDefault.click.sink { [weak self] in
            LSSetDefaultHandlerForURLScheme("http" as CFString, "incognit" as CFString)
            LSSetDefaultHandlerForURLScheme("https" as CFString, "incognit" as CFString)
            self?.close()
        }.store(in: &subs)
        contentView!.addSubview(makeDefault)
        
        let isDefault = Text()
        isDefault.stringValue = NSLocalizedString("Privacy is your default browser", comment: "")
        isDefault.font = .systemFont(ofSize: 14, weight: .medium)
        isDefault.textColor = .secondaryLabelColor
        contentView!.addSubview(isDefault)
        
        titleEngine.topAnchor.constraint(equalTo: contentView!.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        segmented.topAnchor.constraint(equalTo: titleEngine.bottomAnchor, constant: 12).isActive = true
        titleOptions.topAnchor.constraint(equalTo: segmented.bottomAnchor, constant: 40).isActive = true
        dark.topAnchor.constraint(equalTo: titleOptions.bottomAnchor, constant: 12).isActive = true
        safe.topAnchor.constraint(equalTo: dark.bottomAnchor, constant: 4).isActive = true
        trackers.topAnchor.constraint(equalTo: safe.bottomAnchor, constant: 4).isActive = true
        cookies.topAnchor.constraint(equalTo: trackers.bottomAnchor, constant: 4).isActive = true
        popups.topAnchor.constraint(equalTo: cookies.bottomAnchor, constant: 4).isActive = true
        javascript.topAnchor.constraint(equalTo: popups.bottomAnchor, constant: 4).isActive = true
        ads.topAnchor.constraint(equalTo: javascript.bottomAnchor, constant: 4).isActive = true
        
        makeDefault.topAnchor.constraint(equalTo: ads.bottomAnchor, constant: 30).isActive = true
        makeDefault.centerXAnchor.constraint(equalTo: contentView!.centerXAnchor).isActive = true
        makeDefault.widthAnchor.constraint(equalToConstant: 200).isActive = true
        makeDefault.heightAnchor.constraint(equalToConstant: 34).isActive = true
        
        isDefault.centerXAnchor.constraint(equalTo: makeDefault.centerXAnchor).isActive = true
        isDefault.centerYAnchor.constraint(equalTo: makeDefault.centerYAnchor).isActive = true
        
        [titleEngine, titleOptions].forEach {
            $0.leftAnchor.constraint(equalTo: contentView!.safeAreaLayoutGuide.leftAnchor, constant: 60).isActive = true
        }
        
        [segmented, dark, safe, trackers, cookies, popups, javascript, ads].forEach {
            $0.leftAnchor.constraint(equalTo: contentView!.safeAreaLayoutGuide.leftAnchor, constant: 60).isActive = true
            $0.rightAnchor.constraint(equalTo: contentView!.safeAreaLayoutGuide.rightAnchor, constant: -60).isActive = true
        }
        
        if defaultBrowser {
            makeDefault.isHidden = true
        } else {
            isDefault.isHidden = true
        }
    }
    
    private var defaultBrowser: Bool {
        NSWorkspace.shared.urlForApplication(toOpen: URL(string: "http://")!)
            .map {
                $0 == Bundle.main.bundleURL
            } ?? false
    }
}
