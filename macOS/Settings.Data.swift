import AppKit
import WebKit
import Combine
import Sleuth

extension Settings {
    final class Data: NSTabViewItem {
        private var subs = Set<AnyCancellable>()
        
        required init?(coder: NSCoder) { nil }
        override init() {
            super.init(identifier: "Data")
            label = "Data"
            
            let cache = Option(title: "Forget cache", image: "trash")
            cache
                .click
                .sink {
                    NSAlert.delete(title: "Delete cache") { [weak self] in
                        self?.clear()
                        self?.view?.window?.close()
                        Toast.show(message: .init(title: "Deleted cache", icon: "trash"))
                    }
                }
                .store(in: &subs)
            
            let history = Option(title: "Forget history", image: "trash")
            history
                .click
                .sink {
                    NSAlert.delete(title: "Delete history") { [weak self] in
                        cloud.forgetBrowse()
                        self?.view?.window?.close()
                        Toast.show(message: .init(title: "Deleted history", icon: "trash"))
                    }
                }
                .store(in: &subs)
            
            let activity = Option(title: "Forget activity", image: "trash")
            activity
                .click
                .sink {
                    NSAlert.delete(title: "Delete activity") { [weak self] in
                        cloud.forgetActivity()
                        self?.view?.window?.close()
                        Toast.show(message: .init(title: "Deleted activity", icon: "trash"))
                    }
                }
                .store(in: &subs)
            
            let trackers = Option(title: "Forget trackers", image: "trash")
            trackers
                .click
                .sink {
                    NSAlert.delete(title: "Delete trackers") { [weak self] in
                        cloud.forgetBlocked()
                        self?.view?.window?.close()
                        Toast.show(message: .init(title: "Deleted trackers", icon: "trash"))
                    }
                }
                .store(in: &subs)
            
            let everything = Option(title: "Forget everything", image: "flame")
            everything
                .click
                .sink {
                    NSAlert.delete(title: "Delete everything") { [weak self] in
                        cloud.forget()
                        self?.clear()
                        self?.view?.window?.close()
                        Toast.show(message: .init(title: "Deleted everything", icon: "flame"))
                    }
                }
                .store(in: &subs)
            
            var top = view!.topAnchor
            [cache, history, activity, trackers, everything]
                .forEach {
                    view!.addSubview($0)
                    
                    $0.topAnchor.constraint(equalTo: top, constant: top == view!.topAnchor ? 20 : 10).isActive = true
                    $0.centerXAnchor.constraint(equalTo: view!.centerXAnchor).isActive = true
                    top = $0.bottomAnchor
                }
        }
        
        private func clear() {
            HTTPCookieStorage.shared.removeCookies(since: .distantPast)
            [WKWebsiteDataStore.default(), WKWebsiteDataStore.nonPersistent()].forEach {
                $0.fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) {
                    $0.forEach {
                        WKWebsiteDataStore.default().removeData(ofTypes: $0.dataTypes, for: [$0]) { }
                    }
                }
                $0.removeData(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes(), modifiedSince: .distantPast) { }
            }
        }
    }
}
