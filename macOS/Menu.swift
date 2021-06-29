import AppKit

final class Menu: NSMenu, NSMenuDelegate {
    private let status = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    
    required init(coder: NSCoder) { super.init(coder: coder) }
    init() {
        super.init(title: "")
        items = [app, file, edit, page, window, help]
        status.button!.image = NSImage(named: "status")
        status.button!.target = self
        status.button!.action = #selector(triggerStatus)
    }
    
    private var app: NSMenuItem {
        .parent("Privacy", [
                    .child("About", #selector(NSApplication.orderFrontStandardAboutPanel(_:))),
                    .separator(),
                    .child("Preferences...", #selector(App.preferences), ","),
                    .separator(),
                    .child("Hide", #selector(NSApplication.hide), "h"),
                    .child("Hide Others", #selector(NSApplication.hideOtherApplications), "h") {
                        $0.keyEquivalentModifierMask = [.option, .command]
                    },
                    .child("Show all", #selector(NSApplication.unhideAllApplications)),
                    .separator(),
                    .child("Quit", #selector(NSApplication.terminate), "q")])
    }
    
    private var file: NSMenuItem {
        .parent("File", [
                    .child("New Window", #selector(App.newWindow), "n"),
                    .child("New Tab", #selector(App.newTab), "t"),
                    .child("Open Location", #selector(Window.location), "l"),
                    .separator(),
                    .child("Close Window", #selector(Window.shut), "W"),
                    .child("Close Tab", #selector(Window.close), "w"),
                    .separator(),
                    .parent("Share") {
                        $0.submenu!.delegate = self
                    }])
    }
    
    private var edit: NSMenuItem {
        .parent("Edit", [
                    .child("Undo", Selector(("undo:")), "z"),
                    .child("Redo", Selector(("redo:")), "Z"),
                    .separator(),
                    .child("Cut", #selector(NSText.cut), "x"),
                    .child("Copy", #selector(NSText.copy(_:)), "c"),
                    .child("Paste", #selector(NSText.paste), "v"),
                    .child("Delete", #selector(NSText.delete)),
                    .child("Select All", #selector(NSText.selectAll), "a"),
                    .separator(),
                    .parent("Find", [
                        .child("Find", #selector(NSResponder.performTextFinderAction), "f") {
                            $0.tag = .init(NSTextFinder.Action.showFindInterface.rawValue)
                        },
                        .child("Find Next", #selector(NSResponder.performTextFinderAction), "g") {
                            $0.tag = .init(NSTextFinder.Action.nextMatch.rawValue)
                        },
                        .child("Find Previous", #selector(NSResponder.performTextFinderAction), "G") {
                            $0.tag = .init(NSTextFinder.Action.previousMatch.rawValue)
                        },
                        .separator(),
                        .child("Hide Find Banner", #selector(NSResponder.performTextFinderAction), "F") {
                            $0.tag = .init(NSTextFinder.Action.hideFindInterface.rawValue)
                        }
                    ]) {
                        $0.submenu!.delegate = self
                        $0.submenu!.autoenablesItems = false
                    }])
    }
    
    private var page: NSMenuItem {
        .parent("Page") {
            $0.submenu!.delegate = self
            $0.submenu!.autoenablesItems = false
        }
    }
    
    private var window: NSMenuItem {
        .parent("Window") {
            $0.submenu!.delegate = self
        }
    }
    
    private var help: NSMenuItem {
        .parent("Help", [
                    .separator(),
                    .child("Privacy website", #selector(triggerWebsite)) {
                        $0.target = self
                    }])
    }
    
    func menuNeedsUpdate(_ menu: NSMenu) {
        switch menu.title {
        case "Share":
            menu.items = NSSharingService
                .sharingServices(forItems: [url])
                .map { service in
                    .child(service.menuItemTitle, #selector(triggerShare)) {
                        $0.target = self
                        $0.image = service.image
                        $0.representedObject = service
                    }
                } + [
                    .separator(),
                    .child("Copy Link", #selector(triggerCopyLink), "C") {
                        $0.target = self
                        $0.image = .init(systemSymbolName: "doc.on.doc", accessibilityDescription: nil)
                    }]
        case "Window":
            menu.items = [
                .child("Minimize", #selector(NSWindow.miniaturize), "m"),
                .child("Zoom", #selector(NSWindow.zoom), "p"),
                .separator(),
                .child("Bring All to Front", #selector(NSApplication.arrangeInFront)),
                .separator()]
                + (0 ..< NSApp.windows.count)
                .compactMap {
                    switch NSApp.windows[$0] {
                    case is Window:
                        guard NSApp.windows[$0].tabGroup == nil || NSApp.windows[$0] == NSApp.windows[$0].tabGroup?.selectedWindow else { return nil }
                        return (index: $0, title: NSApp.windows[$0].tab.title)
                    case is Trackers, is Activity, is Settings:
                        return (index: $0, title: NSApp.windows[$0].title)
                    default:
                        return nil
                    }
                }
                .map { (index: Int, title: String) in
                    .child(title, #selector(triggerFocus)) {
                        $0.target = self
                        $0.tag = index
                        $0.state = NSApp.mainWindow == NSApp.windows[index] ? .on : .off
                    }
                }
        case "Page":
            let id = (NSApp.keyWindow as? Window)?.id
            
            let browse = id
                .map {
                    tabber
                        .items
                        .value[state: $0].isBrowse
                }
                ?? false
            
            let error = id
                .map {
                    tabber
                        .items
                        .value[state: $0].isError
                }
                ?? false
            
            menu.items = [
                .child("Stop", #selector(triggerStop), ".") {
                    $0.isEnabled = browse
                    $0.target = self
                    $0.representedObject = id
                },
                error
                ? .child("Try Again", #selector(Window.Error.tryAgain), "r")
                : .child("Reload", #selector(triggerReload), "r") {
                    $0.isEnabled = browse
                    $0.target = self
                    $0.representedObject = id
                },
                .separator(),
                .child("Actual Size", #selector(triggerActualSize), "0") {
                    $0.isEnabled = browse
                    $0.target = self
                    $0.representedObject = id
                },
                .child("Zoom In", #selector(triggerZoomIn), "+") {
                    $0.isEnabled = browse
                    $0.target = self
                    $0.representedObject = id
                },
                .child("Zoom Out", #selector(triggerZoomOut), "-") {
                    $0.isEnabled = browse
                    $0.target = self
                    $0.representedObject = id
                }]
        case "Find":
            let browser = (NSApp.keyWindow as? Window)
                .flatMap {
                    $0
                        .contentView
                        .flatMap {
                            $0 as? Browser
                        }
                }
            menu
                .items
                .forEach {
                    switch NSTextFinder.Action(rawValue: $0.tag) {
                    case .hideFindInterface:
                        $0.isEnabled = browser != nil && browser!.isFindBarVisible
                    default:
                        $0.isEnabled = browser != nil
                    }
                }
        default: break
        }
    }
    
    private var url: URL {
        (NSApp.keyWindow as? Window)
            .map(\.id)
            .flatMap {
                tabber
                    .items
                    .value[state: $0]
                    .browse
            }
            .map(cloud
                    .archive
                    .value
                    .page)
            .flatMap(\.access.url)
            ?? URL(string: "https://privacy-inc.github.io/about")!
    }
    
    @objc private func triggerStatus(_ button: NSStatusBarButton) {
        let forget = Forget()
        forget.behavior = .transient
        forget.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
        forget.contentViewController!.view.window!.makeKey()
    }
    
    @objc private func triggerShare(_ item: NSMenuItem) {
        (item.representedObject as? NSSharingService)?
            .perform(withItems: [url])
    }
    
    @objc private func triggerCopyLink() {
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(url.absoluteString, forType: .string)
        Toast.show(message: .init(title: "URL copied", icon: "doc.on.doc.fill"))
    }
    
    @objc private func triggerWebsite() {
        NSApp.open(tab: URL(string: "https://privacy-inc.github.io/about")!, change: true)
    }
    
    @objc private func triggerFocus(_ item: NSMenuItem) {
        NSApp.windows[item.tag].makeKeyAndOrderFront(nil)
    }
    
    @objc private func triggerStop(_ item: NSMenuItem) {
        item
            .representedObject
            .flatMap {
                $0 as? UUID
            }
            .map(session.stop.send)
    }
    
    @objc private func triggerReload(_ item: NSMenuItem) {
        item
            .representedObject
            .flatMap {
                $0 as? UUID
            }
            .map(session.reload.send)
    }
    
    @objc private func triggerActualSize(_ item: NSMenuItem) {
        item
            .representedObject
            .flatMap {
                $0 as? UUID
            }
            .map(session.actualSize.send)
    }
    
    @objc private func triggerZoomIn(_ item: NSMenuItem) {
        item
            .representedObject
            .flatMap {
                $0 as? UUID
            }
            .map(session.zoomIn.send)
    }
    
    @objc private func triggerZoomOut(_ item: NSMenuItem) {
        item
            .representedObject
            .flatMap {
                $0 as? UUID
            }
            .map(session.zoomOut.send)
    }
}
