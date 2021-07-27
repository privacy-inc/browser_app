import SwiftUI

extension Info {
    struct Alternatives: View {
        var body: some View {
            Message(
                title: "",
                message: Purchases.alternatives) { }
                .navigationTitle("Alternatives")
        }
    }

}
