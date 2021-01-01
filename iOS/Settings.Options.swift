import SwiftUI
import Sleuth

extension Settings {
    struct Options: View {
        @AppStorage(Defaults.Key.dark.rawValue) private var dark = true
        @AppStorage(Defaults.Key.secure.rawValue) private var secure = true
        @AppStorage(Defaults.Key.trackers.rawValue) private var trackers = true
        @AppStorage(Defaults.Key.cookies.rawValue) private var cookies = true
        @AppStorage(Defaults.Key.popups.rawValue) private var popups = true
        @AppStorage(Defaults.Key.javascript.rawValue) private var javascript = true
        @AppStorage(Defaults.Key.ads.rawValue) private var ads = true
        
        var body: some View {
            Switch(text: "Force dark mode", value: $dark)
            Switch(text: "Safe browsing", value: $secure)
            Switch(text: "Block trackers", value: $trackers)
            Switch(text: "Block cookies", value: $cookies)
            Switch(text: "Block pop-ups", value: $popups)
            Switch(text: "Allow JavaScript", value: $javascript)
            Switch(text: "Remove ads", value: $ads)
                .padding(.bottom)
        }
    }
}
