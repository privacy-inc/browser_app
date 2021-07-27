import SwiftUI

extension Info {
    struct Why: View {
        var body: some View {
            Message(
                title: "",
                message: Purchases.why) { }
                .navigationTitle("Why purchasing?")
        }
    }
}
