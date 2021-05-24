import SwiftUI

struct Why: View {
    var body: some View {
        Message(
            title: "Why purchasing\nPrivacy Plus?",
            message: """
By purchasing Privacy Plus you are supporting the development and research necessary to fulfil our mission of bringing the most secure and private browser to iOS and macOS.

Compared to other browser alternatives, we at Privacy Inc. are an independent team, we don't have the support of big international corporations.

Furthermore, besides our In-App Purchases we don't monetize using any other mean, i.e. we don't monetize with your personal data, and we don't provide advertisements, in fact, is in our mission to remove ads from the web.
""") { }
            .navigationTitle("Privacy Plus")
    }
}
