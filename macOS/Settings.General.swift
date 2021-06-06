import AppKit
import Combine
import Sleuth

extension Settings {
    final class General: NSTabViewItem {
        private var subs = Set<AnyCancellable>()
        
        required init?(coder: NSCoder) { nil }
        override init() {
            super.init(identifier: "General")
            label = "General"
            
            let engineTitle = Text()
            engineTitle.font = .preferredFont(forTextStyle: .callout)
            engineTitle.textColor = .secondaryLabelColor
            engineTitle.stringValue = "Search engine"
            view!.addSubview(engineTitle)
            
            let engine = Segmented(items: ["Ecosia", "Google"])
            engine.select.send(.init(cloud
                .archive
                .value
                .settings
                .engine
                .rawValue))
            engine
                .select
                .sink {
                    Engine(rawValue: .init($0))
                        .map(cloud
                                .engine)
                }
                .store(in: &subs)
            view!.addSubview(engine)
            
            let browserTitle = Text()
            browserTitle.font = .preferredFont(forTextStyle: .callout)
            browserTitle.textColor = .secondaryLabelColor
            browserTitle.stringValue = isDefault ? """
Make this app your default browser and all websites will open automatically on Privacy.
""" : """
Privacy as your Default Browser
"""
            browserTitle.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
            view!.addSubview(browserTitle)
            
            let locationTitle = Text()
            locationTitle.font = .preferredFont(forTextStyle: .callout)
            locationTitle.textColor = .secondaryLabelColor
            locationTitle.stringValue = """
This app will never access your location, but may prompt you if a website is asking for it.
Enable and disable this on System Preferences.
"""
            locationTitle.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
            view!.addSubview(locationTitle)
            
            let location = Option(title: "Location", image: "location")
            location
                .click
                .sink {
                    NSWorkspace
                        .shared
                        .open(URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_LocationServices")!)
                }
                .store(in: &subs)
            view!.addSubview(location)
            
            engineTitle.topAnchor.constraint(equalTo: view!.topAnchor, constant: 20).isActive = true
            engineTitle.leftAnchor.constraint(equalTo: engine.leftAnchor).isActive = true
            
            engine.topAnchor.constraint(equalTo: engineTitle.bottomAnchor, constant: 10).isActive = true
            engine.centerXAnchor.constraint(equalTo: view!.centerXAnchor).isActive = true
            engine.widthAnchor.constraint(equalToConstant: 280).isActive = true
            
            browserTitle.topAnchor.constraint(equalTo: engine.bottomAnchor, constant: 30).isActive = true
            browserTitle.leftAnchor.constraint(equalTo: engine.leftAnchor).isActive = true
            browserTitle.rightAnchor.constraint(equalTo: engine.rightAnchor).isActive = true
            
            locationTitle.topAnchor.constraint(equalTo: browserTitle.bottomAnchor, constant: 90).isActive = true
            locationTitle.leftAnchor.constraint(equalTo: engine.leftAnchor).isActive = true
            locationTitle.rightAnchor.constraint(equalTo: engine.rightAnchor).isActive = true
            
            location.topAnchor.constraint(equalTo: locationTitle.bottomAnchor, constant: 10).isActive = true
            location.centerXAnchor.constraint(equalTo: view!.centerXAnchor).isActive = true
            
            if isDefault {
                let browser = Text()
                browser.stringValue = "Defalt Browser"
                browser.font = .preferredFont(forTextStyle: .callout)
                view!.addSubview(browser)
                
                let icon = Image(icon: "checkmark.circle.fill")
                icon.symbolConfiguration = .init(textStyle: .title3)
                icon.contentTintColor = .controlAccentColor
                view!.addSubview(icon)
                
                browser.centerYAnchor.constraint(equalTo: icon.centerYAnchor).isActive = true
                browser.leftAnchor.constraint(equalTo: icon.rightAnchor, constant: 5).isActive = true
                
                icon.leftAnchor.constraint(equalTo: engine.leftAnchor).isActive = true
                icon.topAnchor.constraint(equalTo: browserTitle.bottomAnchor, constant: 20).isActive = true
            } else {
                let browser = Option(title: "Make default browser", image: "magnifyingglass")
                browser
                    .click
                    .sink { [weak self] in
                        LSSetDefaultHandlerForURLScheme(URL.Scheme.http.rawValue as CFString, "incognit" as CFString)
                        LSSetDefaultHandlerForURLScheme(URL.Scheme.https.rawValue as CFString, "incognit" as CFString)
                        self?.view?.window?.close()
                    }
                    .store(in: &subs)
                view!.addSubview(browser)
                
                browser.topAnchor.constraint(equalTo: browserTitle.bottomAnchor, constant: 10).isActive = true
                browser.centerXAnchor.constraint(equalTo: view!.centerXAnchor).isActive = true
            }
        }
        
        private var isDefault: Bool {
            NSWorkspace
                .shared
                .urlForApplication(toOpen: URL(string: URL.Scheme.http.rawValue + "://")!)
                .map {
                    $0.lastPathComponent == Bundle.main.bundleURL.lastPathComponent
                }
                ?? false
        }
    }
}
