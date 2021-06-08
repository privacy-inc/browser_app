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
            
            let cache = Option.Basic(title: "Forget cache", image: "trash")
            cache
                .click
                .sink {
                    NSAlert.delete(title: "Delete cache", icon: "trash.fill") { [weak self] in
                        self?.clear()
                        self?.view?.window?.close()
                        Toast.show(message: .init(title: "Deleted cache", icon: "trash.fill"))
                    }
                }
                .store(in: &subs)
            
            let history = Option.Basic(title: "Forget history", image: "clock")
            history
                .click
                .sink {
                    NSAlert.delete(title: "Delete history", icon: "clock.fill") { [weak self] in
                        cloud.forgetBrowse()
                        self?.view?.window?.close()
                        Toast.show(message: .init(title: "Deleted history", icon: "clock.fill"))
                    }
                }
                .store(in: &subs)
            
            let activity = Option.Basic(title: "Forget activity", image: "chart.bar.xaxis")
            activity
                .click
                .sink {
                    NSAlert.delete(title: "Delete activity", icon: "chart.bar.xaxis") { [weak self] in
                        cloud.forgetActivity()
                        self?.view?.window?.close()
                        Toast.show(message: .init(title: "Deleted activity", icon: "chart.bar.xaxis"))
                    }
                }
                .store(in: &subs)
            
            let trackers = Option.Basic(title: "Forget trackers", image: "shield.lefthalf.fill")
            trackers
                .click
                .sink {
                    NSAlert.delete(title: "Delete trackers", icon: "shield.lefthalf.fill") { [weak self] in
                        cloud.forgetBlocked()
                        self?.view?.window?.close()
                        Toast.show(message: .init(title: "Deleted trackers", icon: "shield.lefthalf.fill"))
                    }
                }
                .store(in: &subs)
            
            let everything = Option.Destructive(title: "Forget everything", image: "flame.fill")
            everything
                .click
                .sink {
                    NSAlert.delete(title: "Delete everything", icon: "flame.fill") { [weak self] in
                        cloud.forget()
                        self?.clear()
                        self?.view?.window?.close()
                        Toast.show(message: .init(title: "Deleted everything", icon: "flame.fill"))
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
