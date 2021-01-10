import AppKit
import Sleuth
import Combine

final class Preferences: NSWindow {
    private var subs = Set<AnyCancellable>()
    
    init() {
        super.init(contentRect: .init(x: 0, y: 0, width: 500, height: 800),
                   styleMask: [.closable, .titled, .fullSizeContentView], backing: .buffered, defer: false)
        toolbar = .init()
        title = NSLocalizedString("Preferences", comment: "")
        titlebarAppearsTransparent = true
        collectionBehavior = .fullScreenNone
        isReleasedWhenClosed = false
        center()
        
        let titleEngine = Text()
        titleEngine.stringValue = NSLocalizedString("Search engine", comment: "")
        
        let segmented = Segmented(items: ["Google", "Ecosia"])
        segmented.selected.value = Defaults.engine == .google ? 0 : 1
        segmented.selected.dropFirst().sink {
            Defaults.engine = $0 == 0 ? .google : .ecosia
        }.store(in: &subs)
        contentView!.addSubview(segmented)
        
        let titleOptions = Text()
        titleOptions.stringValue = NSLocalizedString("Options", comment: "")
        
        let diclaimerOptions = Text()
        diclaimerOptions.stringValue = NSLocalizedString("You need to reopen your tabs\nfor these changes to become effective", comment: "")
        diclaimerOptions.textColor = .secondaryLabelColor
        diclaimerOptions.font = .systemFont(ofSize: 11, weight: .light)
        contentView!.addSubview(diclaimerOptions)
        
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
        
        let location = Toggle(title: NSLocalizedString("Access to your location", comment: ""))
        location.value.value = Defaults.location
        location.value.dropFirst().sink {
            Defaults.location = $0
        }.store(in: &subs)
        contentView!.addSubview(location)
        
        let titleAdvanced = Text()
        titleAdvanced.stringValue = NSLocalizedString("Advanced", comment: "")
        
        let browser = defaultBrowser
        let makeDefault = Button(title: NSLocalizedString(browser ? "Default browser" : "Make default browser", comment: ""), icon: NSImage(named: "logoSmall")!)
        if !browser {
            makeDefault.click.sink { [weak self] in
                LSSetDefaultHandlerForURLScheme(Scheme.http.rawValue as CFString, "incognit" as CFString)
                LSSetDefaultHandlerForURLScheme(Scheme.https.rawValue as CFString, "incognit" as CFString)
                self?.close()
            }.store(in: &subs)
        } else {
            makeDefault.state = .off
        }
        contentView!.addSubview(makeDefault)
        
        let authorization = Button(title: NSLocalizedString("Location authorization", comment: ""), icon: NSImage(systemSymbolName: "location", accessibilityDescription: nil)!)
        authorization.click.sink {
            NSWorkspace.shared.open(URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_LocationServices")!)
        }.store(in: &subs)
        contentView!.addSubview(authorization)
        
        [titleEngine, titleOptions, titleAdvanced].forEach {
            $0.textColor = .secondaryLabelColor
            $0.font = .systemFont(ofSize: 12, weight: .regular)
            contentView!.addSubview($0)
            
            $0.leftAnchor.constraint(equalTo: contentView!.safeAreaLayoutGuide.leftAnchor, constant: 90).isActive = true
        }
        
        titleEngine.topAnchor.constraint(equalTo: contentView!.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        segmented.topAnchor.constraint(equalTo: titleEngine.bottomAnchor, constant: 12).isActive = true
        titleOptions.topAnchor.constraint(equalTo: segmented.bottomAnchor, constant: 40).isActive = true
        diclaimerOptions.leftAnchor.constraint(equalTo: contentView!.safeAreaLayoutGuide.leftAnchor, constant: 90).isActive = true
        diclaimerOptions.topAnchor.constraint(equalTo: titleOptions.bottomAnchor, constant: 2).isActive = true
        dark.topAnchor.constraint(equalTo: diclaimerOptions.bottomAnchor, constant: 12).isActive = true
        safe.topAnchor.constraint(equalTo: dark.bottomAnchor, constant: 4).isActive = true
        trackers.topAnchor.constraint(equalTo: safe.bottomAnchor, constant: 4).isActive = true
        cookies.topAnchor.constraint(equalTo: trackers.bottomAnchor, constant: 4).isActive = true
        popups.topAnchor.constraint(equalTo: cookies.bottomAnchor, constant: 4).isActive = true
        javascript.topAnchor.constraint(equalTo: popups.bottomAnchor, constant: 4).isActive = true
        ads.topAnchor.constraint(equalTo: javascript.bottomAnchor, constant: 4).isActive = true
        location.topAnchor.constraint(equalTo: ads.bottomAnchor, constant: 4).isActive = true
        titleAdvanced.topAnchor.constraint(equalTo: location.bottomAnchor, constant: 40).isActive = true
        makeDefault.topAnchor.constraint(equalTo: titleAdvanced.bottomAnchor, constant: 12).isActive = true
        authorization.topAnchor.constraint(equalTo: makeDefault.bottomAnchor, constant: 4).isActive = true
        
        [segmented, dark, safe, trackers, cookies, popups, javascript, ads, location, makeDefault, authorization].forEach {
            $0.leftAnchor.constraint(equalTo: contentView!.safeAreaLayoutGuide.leftAnchor, constant: 90).isActive = true
            $0.rightAnchor.constraint(equalTo: contentView!.safeAreaLayoutGuide.rightAnchor, constant: -90).isActive = true
        }
    }
    
    private var defaultBrowser: Bool {
        NSWorkspace.shared.urlForApplication(toOpen: URL(string: Scheme.http.url)!)
            .map {
                $0 == Bundle.main.bundleURL
            } ?? false
    }
}
