import SwiftUI

extension Info {
    struct Alternatives: View {
        var body: some View {
            Message(
                title: "Alternatives\nto purchasing",
                message: """
    We ask you to purchase Privacy Plus only if you consider it a good product, if you think is helping you in some way and if you feel the difference between a mainstream browser and Privacy.

    But we are not going to force you to buy it; you will be reminded from time to time that it would be a good idea if you support us with your purchase, but you can as easily ignore the pop-up and continue using Privacy.

    We believe we can help you browse securely and privatly even if you can't support us at the moment.
    """) { }
                .navigationTitle("Privacy Plus")
        }
    }

}
