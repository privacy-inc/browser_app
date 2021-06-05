import SwiftUI

extension Info {
    struct Why: View {
        var body: some View {
            Message(
                title: "Why purchasing\nPrivacy Plus?",
                message: Purchases.why) { }
                .navigationTitle("Privacy Plus")
        }
    }
}
