import SwiftUI
import Sleuth

extension Settings {
    struct Options: View {
        @AppStorage(Defaults.Key.dark.rawValue) private var dark = true
        @AppStorage(Defaults.Key.secure.rawValue) private var secure = true
        
        var body: some View {
            Switch(text: "Force dark mode", value: $dark)
        }
    }
}
