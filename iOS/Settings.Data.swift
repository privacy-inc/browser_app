import SwiftUI
import WebKit
import Archivable

extension Settings {
    struct Data: View {
        @Environment(\.presentationMode) private var visible
        
        var body: some View {
            List {
                Section {
                    Cell(title: "Forget cache") {
                        clear()
                        dismiss()
                    }
                    Cell(title: "Forget history") {
                        Cloud.shared.forgetBrowse()
                        dismiss()
                    }
                    Cell(title: "Forget activity") {
                        Cloud.shared.forgetActivity()
                        dismiss()
                    }
                    Cell(title: "Forget trackers") {
                        Cloud.shared.forgetBlocked()
                        dismiss()
                    }
                }
                .foregroundColor(.primary)
                
                Section {
                    Cell(title: "Forget everything") {
                        Cloud.shared.forget()
                        clear()
                        dismiss()
                    }
                    .foregroundColor(.pink)
                }
            }
            .listStyle(GroupedListStyle())
            .navigationBarTitle("Clear data")
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
        
        private func dismiss() {
            visible.wrappedValue.dismiss()
        }
    }
}
