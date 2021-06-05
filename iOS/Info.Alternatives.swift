import SwiftUI

extension Info {
    struct Alternatives: View {
        var body: some View {
            Message(
                title: "Alternatives\nto purchasing",
                message: Purchases.alternatives) { }
                .navigationTitle("Privacy Plus")
        }
    }

}
