import SwiftUI

extension Info {
    struct Why: View {
        var body: some View {
            Message(
                title: "Privacy +\nWhy purchasing?",
                message: Purchases.why) { }
                .navigationTitle("Privacy +")
        }
    }
}
